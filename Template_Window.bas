#include "fbgfx.bi"
using fb

'--Create window
dim shared as ushort scr_width,scr_height,scr_bit,scr_pages,scr_type
scr_width = 800     'width of window
scr_height = 600    'height of window
scr_bit = 16        'bitdepth of window
scr_pages = 1       'number of windows
scr_type = 0        'type of window [GFX_WINDOWED, GFX_FULLSCREEN, GFX_NO_SWITCH, GFX_NO_FRAME, GFX_SHAPED_WINDOW, GFX_ALWAYS_ON_TOP]
screenres scr_width,scr_height,scr_bit,scr_pages,scr_type
windowtitle "Title" 'Title of the window

'--Variables
dim shared e as EVENT

'--Subs
sub Controller()
    if ScreenEvent(@e) then
        select case e.type
        '--KEYBOARD
        '-e.scancode (multikey inputs)
        '-e.ascii (value of key)
        case EVENT_KEY_PRESS            'A key was pushed
            if e.ascii > 0 then
                'Known key
            else
                'Unknown key
            end if
        case EVENT_KEY_RELEASE          'A key was release
            if e.ascii > 0 then
                'Known key
            else
                'Unknown key
            end if
        case EVENT_KEY_REPEAT           'A key is being held down
            if e.ascii > 0 then
                'Known key
            else
                'Unknown key
            end if
        '--MOUSE
        '-e.button ["left"|"right"|"middle"]
        '-e.x (x pos of mouse)
        '-e.y (y pos of mouse)
        '-e.dx (x delta of mouse)
        '-e.dy (y delta of mouse)
        '-e.z (scroll wheel position)
        '-e.w (horizontal scroll wheel position)
        case EVENT_MOUSE_MOVE           'The mouse moved
        
        case EVENT_MOUSE_BUTTON_PRESS   'A mouse button was pressed
            
        case EVENT_MOUSE_BUTTON_RELEASE 'A mouse button was released
            
        case EVENT_MOUSE_DOUBLE_CLICK   'A mouse button was pressed twice
        
        case EVENT_MOUSE_WHEEL          'The mouse wheel moved
            
        case EVENT_MOUSE_HWHEEL         'Horizontal mouse wheel used (Windows only)
            
        case EVENT_MOUSE_ENTER          'The mouse entred the program window
            
        case EVENT_MOUSE_EXIT           'The mouse exited the program window
        
        '--WINDOW
        case EVENT_WINDOW_GOT_FOCUS     'The window gained focus
            
        case EVENT_WINDOW_LOST_FOCUS     'The window lost focus
        
        case EVENT_WINDOW_CLOSE         'The window was closed
            end
        end select
    end if
end sub

sub Render()
    screenlock
        cls
        'Render stuff here
    screenunlock
end sub

'--Window loop
do
    Controller()
    'Render()
    
    sleep 15
loop until multikey(sc_escape)