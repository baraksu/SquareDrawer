 ;version 108 
.MODEL small
.STACK 100h
.DATA
length dw 0
char db 0
crlf db 13,10,'$'
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

menu:    
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
    
    lea dx,msg7
    mov ah,09h
    int 21h
    
    jmp menu
     
Square1: 
    
    lea dx, msg1
    mov ah,09h
    int 21h
    push offset length
    call GetLength
    mov bx,[length] 
    
    lea dx, msg2
    mov ah,09h
    int 21h                
    
    push offset char
    push bx
    call GetChar
    push dx 
    
    lea dx, msg3
    mov ah,09h
    int 21h
    
    pop dx
    mov [length],bx
    mov [char],cl
    mov [crlf],dl
    push dx
    push bx
    xor ch,ch
    push cx
    mov [crlf],dl
    call FirstSquare
    jmp menu
    
Square2:

    lea dx, msg1
    mov ah,09h
    int 21h
    push offset length
    call GetLength
    mov bx,[length] 
    
    lea dx, msg2
    mov ah,09h
    int 21h                
    
    push offset char
    push bx
    call GetChar
    push dx 
 
    xor dx,dx
    mov dl,crlf
    push dx
    push bx
    xor ch,ch
    push cx
            
    lea dx, msg4
    mov ah,09h
    int 21h
    
    xor dx,dx
    xor ax,ax
    xor bx,bx
    
    pop ax;char
    pop bx;length
    pop dx;crlf
    
    push dx
    push ax
    push bx
    call SecondSquare
    jmp menu
    
 exit:
    lea dx,msg5
    mov ah,09h
    int 21h
    call EndProgram
    
;---------------------------------------------
;proc 1
proc GetLength     
    push bp
    mov bp,sp    

    xor ax,ax
    xor bx,bx    
    mov bx,[bp+4]
    
    mov ah,01h
    int 21h  
    sub ax,130h
    mov [length],ax

    pop bp
    ret 4
endp GetLength
;---------------------------------------------   
;proc 2 
proc GetChar    
    push bp
    mov bp,sp
    
    xor ax,ax 
    xor bx,bx
    
    mov bx,[bp+6]
    
    mov ah,01h
    int 21h     
    xor dx,dx
    mov dl,crlf
    sub ax,100h 
    mov [char],al

    mov cl,[char]
    mov bx,[bp+4]
    pop bp
    ret 
endp GetChar 
;---------------------------------------------
;proc 3
proc FirstSquare
    push bp
    mov bp,sp  
    
    mov cx,[bp+6]

FillSquare:   
    push cx
    mov cx,bx

DrawSquare:

    mov dl,[bp+4]
    mov ah,02h
    int 21h  
    loop DrawSquare
    
    lea dx,[crlf]
    mov ah,09h
    int 21h 
    pop cx
    loop FillSquare 
    
    pop bp
    ret 8
endp FirstSquare

;----------------------------------------------
;proc 4
proc SecondSquare
   push bp
   mov bp,sp
   
   mov bx,[bp+4]
   mov cx,bx
   
DrawFirstLine:
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    loop DrawFirstLine
    mov dx,[bp+8]
    mov [crlf],dl
    
    lea dx,[crlf]
    mov ah,09h
    int 21h
    
    xor cx,cx
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
    
    lea dx,[crlf]
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
    
;---------------------------------------------
;proc 5
proc EndProgram   
    mov ah,01h
    int 21h
 
    mov ah,4Ch
    int 21h
    endp EndProgram
END     