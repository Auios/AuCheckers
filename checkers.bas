#include "fbgfx.bi"
#include "AuLib.bi"

using fb,auios

const NULL as any ptr = 0

declare function AuBLoad(byref fileName as const string) as any ptr
declare function drawBoard() as integer 'as any ptr

dim shared as AuWindow wnd
wnd.set(800,600,,,,"Checkers")
wnd.create()

'dim as any ptr board
'board = imageCreate(512,512)
'board = drawBoard()

do
    screenlock
    cls
    drawBoard()
    screenunlock
    
    sleep(1,1)
loop until multikey(sc_escape)

'=====Cleanup
'imageDestroy(board)
wnd.destroy()

end 0

'============================================

function AuBLoad(byref fileName as const string) as any ptr
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

function drawBoard() as integer 'as any ptr
    dim as any ptr blackTile,whiteTile,board
    dim as ushort imgSz,boardSz
    dim as ubyte switch
    switch = 1
    imgSz = 64
    boardSz = 8*imgSz
    
    blackTile = AuBLoad("data/blackTile.bmp")
    whiteTile = AuBLoad("data/whiteTile.bmp")
    
    for y as integer = 0 to 7
        for x as integer = 0 to 7
            if(switch) then
                put(x*imgSz,y*imgSz),blackTile,pset
            else
                put(x*imgSz,y*imgSz),whiteTile,pset
            end if
            switch = switch xor 1
        next x
        switch = switch xor 1
    next y
    
    'board = imageCreate(boardSz,boardSz)
    'get(0,0)-(boardSz,boardSz),board
    
    imageDestroy(blackTile)
    imageDestroy(whiteTile)
    
    return 0
    'return board
end function