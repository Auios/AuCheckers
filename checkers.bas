#include "fbgfx.bi"
#include "AuLib.bi"
#include "crt.bi"

#define USE_WASD 1
#define USE_MOUSE 1

using fb,auios

declare function AuBLoad(byref fileName as const string) as any ptr
declare function loadBoard() as any ptr
declare function loadCursor() as any ptr
declare function controller(byref e as event) as integer
declare function render() as integer
declare function restartGame() as integer

dim shared as AuWindow wnd
dim shared as any ptr board,cursor

dim shared as boolean runApp
dim as event e
dim shared as ushort curX,curY
dim shared as ubyte tile(0 to 7,0 to 7)

enum
    empty
    black
    blackKing
    white
    whiteKing
end enum

runApp = true

printf(!"Create: wnd\n")

wnd.set(800,600,,,,"Checkers")
wnd.create()

printf(!"Create: board\n")
board = imageCreate(512,512)
board = loadBoard()

printf(!"Create: cursor\n")
cursor = imageCreate(64,64)
cursor = loadCursor()

restartGame()

do
    render()
    controller(e)
    
    sleep(1,1)
loop until runApp = false

'===Cleanup===
printf(!"Destroy: board\n")
imageDestroy(board)

printf(!"Destroy: cursor\n")
imageDestroy(cursor)

printf(!"Destroy: wnd\n")
wnd.destroy()

end 0

'============================================

function AuBLoad(byref fileName as const string) as any ptr
    printf(!"Load media: '%s'\n",fileName)
    dim as long ff,bw,bh
    dim as any ptr img
    
    ff = freeFile()
    if(open(filename for binary access read as #ff) <> 0) then return NULL
    
    get #ff, 19, bw
    get #ff, 23, bh
    
    close #ff
    
    img = imageCreate(bw,abs(bh))
    if img = NULL then return NULL
    
    if bload(fileName, img) <> 0 then
        imageDestroy(img)
        return NULL
    end if
    
    return img
end function

function loadBoard() as any ptr
    dim as any ptr blackTile,whiteTile,board
    dim as ushort imgSz,boardSz
    dim as ubyte switch
    dim as string fileNameBlackTile,fileNameWhiteTile
    
    switch = 1
    imgSz = 64
    boardSz = 8*imgSz
    fileNameBlackTile = "data/blackTile.bmp"
    fileNameWhiteTile = "data/whiteTile.bmp"
    
    blackTile = AuBLoad(fileNameBlackTile)
    whiteTile = AuBLoad(fileNameWhiteTile)
    
    for yy as integer = 0 to 7
        for xx as integer = 0 to 7
            if(switch) then
                put(xx*imgSz,yy*imgSz),blackTile,pset
            else
                put(xx*imgSz,yy*imgSz),whiteTile,pset
            end if
            switch = switch xor 1
            
            tile(xx,yy) = empty
        next xx
        switch = switch xor 1
    next yy
    
    board = imageCreate(boardSz,boardSz)
    get(0,0)-(boardSz-1,boardSz-1),board
    
    printf(!"Destroy media: '%s'\n",fileNameBlackTile)
    imageDestroy(blackTile)
    printf(!"Destroy media: '%s'\n",fileNameWhiteTile)
    imageDestroy(whiteTile)
    
    return board
end function

function restartGame() as integer
    printf(!"Game restart!\n")
    dim as ubyte switch
    
    switch = 1
    
    for yy as integer = 0 to 2
        for xx as integer = 0 to 7
            if(switch) then tile(xx,yy) = white
            switch = switch xor 1
        next xx
        switch = switch xor 1
    next yy
    
    for yy as integer = 5 to 7
        for xx as integer = 0 to 7
            if(switch) then tile(xx,yy) = black
            switch = switch xor 1
        next xx
        switch = switch xor 1
    next yy
    
    return 0
end function

function loadCursor() as any ptr
    dim as any ptr cursor
    dim as ushort imgSz
    
    imgSz = 64
    cursor = imageCreate(imgSz,imgSz)
    
    line(0,0)-(imgSz-1,imgSz-1),rgb(255,0,255),bf
    line(0,0)-(imgSz-1,imgSz-1),,b
    line(1,1)-(imgSz-2,imgSz-2),,b
    
    get(0,0)-(imgSz-1,imgSz-1),cursor
    
    return cursor
end function

function render() as integer
    
    dim as integer checkerSz
    
    checkerSz = 24
    
    screenlock
        cls
        put(0,0),board
        
        for yy as integer = 0 to 7
            for xx as integer = 0 to 7
                select case tile(xx,yy)
                case white
                    circle(xx*64+31,yy*64+31),checkerSz,rgb(220,220,220),,,,f
                    exit select
                    
                case black
                    circle(xx*64+31,yy*64+31),checkerSz,rgb(50,50,50),,,,f
                    exit select
                end select
            next xx
        next yy
        
        put(curX*64,curY*64),cursor,trans
        draw string(600,20),"Tile: " & tile(curX,curY)
    screenunlock
    
    return 0
end function

function controller(byref e as event) as integer
    if(screenEvent(@e)) then
        select case e.type
        case event_key_press
            select case e.scancode
            case SC_ESCAPE
                runApp = false
                exit select
                
            #if(USE_WASD = 1)
            case SC_W
                if curY > 0 then curY-=1
                exit select
            case SC_S
                if curY < 7 then curY+=1
                exit select
            case SC_A
                if curX > 0 then curX-=1
                exit select
            case SC_D
                if curX < 7 then curX+=1
                exit select
            #endif
            end select
            
        case event_window_close
            runApp = false
            
        case event_mouse_button_press
            select case e.button
            case button_left
                exit select
                
            end select
            
        #if(USE_MOUSE = 1)
        case event_mouse_move
            for yy as integer = 0 to 7
                for xx as integer = 0 to 7
                    if(e.x > xx*64 AND e.x < xx*64+63) then
                        if(e.y > yy*64 AND e.y < yy*64+63) then
                            curX = xx
                            curY = yy
                        end if
                    end if
                next xx
            next yy
            exit select
        #endif
        end select
    end if
    
    return 0
end function
