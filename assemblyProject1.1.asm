 ;version 108 
.MODEL small
.STACK 100h
.DATA
length db 0 ;that would be the length of the lines and the rows in the square.
char db 0 ;this is the char that the square would be made of.
crlf db 13,10,'$';this is being used as an enter, evey time I need to get down with one line.
msg1 db 13,10,'please enter the square length',13,10,'$'
msg2 db 13,10,'please enter the char',13,10,'$'
msg3 db 13,10,'the full square: ',13,10,'$'
msg4 db 13,10,'the empty square: ',13,10,'$'
msg5 db 13,10,'that was my projact hope you like it!,please hit any key to exit',13,10,'$'
msg6 db 13,10,'press: a for full square,b for empty square, and e to exit: ',13,10,'$'
msg7 db 13,10,'invalid char.',13,10,'$' 
.CODE 
start: 
    mov ax,@data
    mov ds,ax

    call menu 
Square1: 
    
    push offset length
    call GetLength
    cmp al,1
    jbe InvalidInput
    xor bx,bx
    mov bl,[length]                
    
    push offset char
    call GetChar
    
    xor bx,bx
    mov bl,length
    push bx
    xor ch,ch
    push cx
    call FirstSquare
    jmp start
    
Square2:

    push offset length
    call GetLength 
    cmp al,2
    jbe InvalidInput
    mov bl,[length]                
    
    push offset char
    call GetChar
    
    push cx;char
    push bx;length
    call SecondSquare
    jmp start
 InvalidInput:
    call invalid
    jmp start   
 exit:
    call EndProgram
    
;--------------------------------------------------------------------
;proc 1 - GetLength, the parameter that you need use is: length,msg1.
proc GetLength     
    push bp
    mov bp,sp    

    lea dx, msg1
    mov ah,09h
    int 21h    
    
    mov ah,01h
    int 21h  
    sub al,30h 
    cmp al,0
    jb InvalidInput    
    cmp al,9
    ja InvalidInput
    
    mov bl,al
    mov cl,10
    mul cl 
    mov bl,al
    
    mov ah,01h
    int 21h 
    sub al,30h
    cmp al,0
    jb InvalidInput    
    cmp al,9
    ja InvalidInput 
    
    add al,bl 
    mov [length],al
    
    pop bp
    ret 4
endp GetLength 
;the proc getting into the var length the input that the user put to be the length.
;----------------------------------------------------------------------------------   
;proc 2 - GetChar, the parameter that you need use is: char,msg2.
proc GetChar    
    push bp
    mov bp,sp 
    
    lea dx, msg2
    mov ah,09h
    int 21h 
    
    mov ah,01h
    int 21h     
    mov [char],al

    mov cl,char
    pop bp
    ret 
endp GetChar
;the proc getting into the var char the input that the user put to be the square char.
;-------------------------------------------------------------------------------------
;proc 3 - FirstSquare, the parameter that you need use is: length,char,crlf,msg3.
proc FirstSquare
    push bp
    mov bp,sp
    
    lea dx, msg3
    mov ah,09h
    int 21h  
    
    mov cx,[bp+6]

FillSquare:   
    push cx
    mov cx,bx

DrawSquare:

    mov dl,[bp+4]
    mov ah,02h
    int 21h  
    loop DrawSquare
    
    lea dx,crlf
    mov ah,09h
    int 21h 
    pop cx
    loop FillSquare 
    
    pop bp
    ret 6
endp FirstSquare
;the proc is drawing the full square, and printing a full square in the length and char the user input.
;------------------------------------------------------------------------------------------------------
;proc 4 - SecondSquare, the parameter that you need use is: length,char,crlf,msg4.
proc SecondSquare
   push bp
   mov bp,sp 
   
   lea dx, msg4
   mov ah,09h
   int 21h
   
   mov bx,[bp+4]
   mov cx,bx
   
DrawFirstLine:
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    loop DrawFirstLine
    
    lea dx,crlf
    mov ah,09h
    int 21h

    mov cx,bx
    sub cx,2h
DrawMiddle:
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    
    push cx
    
    mov cx,bx
    sub cx,2h
DrawSpaces:
    mov dl,' '
    mov ah,02h
    int 21h
    loop DrawSpaces
    
    
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    
    lea dx,crlf
    mov ah,09h
    int 21h
    pop cx
    loop DrawMiddle
    mov cx,bx
DrawLastLine:
    mov dl,char
    mov ah,02h
    int 21h
    loop DrawLastLine
    
    pop bp
    ret 6
endp FirstSquare
;the proc is drawing the empty square, and printing each line with spaces, so it would look like its empty.
;----------------------------------------------------------------------------------------------------------
;proc 5 - invalid, the parameter you need to use is: msg7.
proc invalid
    lea dx,msg7
    mov ah,09h
    int 21h
    
    ret
endp invalid   
;the proc informs the user that the input he did is invalid.
;-----------------------------------------------------------
;proc 6 - menu, the parameter you need to use is: msg6.
proc menu 
    
    lea dx,msg6
    mov ah,09h
    int 21h
    
    mov ah,01h
    int 21h
   
    cmp al,'a'
    je Square1
    
    cmp al,'b'
    je Square2
    
    cmp al,'e'
    je exit
    
    call invalid
    jmp menu
    ret
endp menu
;the proc checks which act the user wants to do, and by the it direct him to the label he needs.
;-----------------------------------------------------------------------------------------------
;proc 7 - EndProgram,  the parameter you need to use is: msg5.
proc EndProgram 
    
    lea dx,msg5
    mov ah,09h
    int 21h
      
    mov ah,01h
    int 21h
 
    mov ah,4Ch
    int 21h
    endp EndProgram
END
;the proc writing the user that the program ended and then asks him for note, then is ends the program.
;------------------------------------------------------------------------------------------------------  