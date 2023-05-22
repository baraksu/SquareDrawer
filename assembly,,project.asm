 ; version 100
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

.CODE 
start:
    mov ax,@data
    mov ds,ax 
    
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
    
    lea dx,msg3
    mov ah,09h
    int 21h  
    
    mov [length],bx
    mov [char],cl
     
    xor bx,bx 
    mov bl,char
    push bx   
    
    push [length]
    
    mov crlf,0Dh
    xor dx,dx
    mov dl,crlf
    push dx
    call FirstSquare
    

    xor bx,bx
    mov bl,char
    push bx      
    
    xor dx,dx
    mov dl,[crlf]
    push dx
    push [length]
    
        
    lea dx, msg4
    mov ah,09h
    int 21h
    
    xor dx,dx
    xor ax,ax
    xor bx,bx
    
    pop ax;length
    pop dx;crlf
    pop bx;char 
    
    push dx
    push ax
    push bx
    call SecondSquare    
;---------------------------------------------    
proc GetLength     
    push bp
    mov bp,sp    

    xor ax,ax
    xor bx,bx    
    mov bx,[bp+4]
    
    mov ah,01h
    int 21h  
    sub ax,130h
    mov [byte ptr [bp+2]:[bp+4]],ax

    pop bp
    ret 4
    endp GetLength 
;---------------------------------------------
proc GetChar    
    push bp
    mov bp,sp
    
    xor ax,ax 
    xor bx,bx
    
    mov bx,[bp+6]
    
    mov ah,01h
    int 21h  
    sub ax,100h
    mov [byte ptr [bp+2]:[bp+6]],ax

    mov cl,[byte ptr [bp+2]:[bp+6]]
    mov bx,[bp+4]
    pop bp
    ret 6
    endp GetChar  
;---------------------------------------------
proc FirstSquare    
    push bp
    mov bp,sp  
    
    mov cx,[bp+6]
    xor bx,bx
    mov bx,cx
FillSquare:   
    push cx
    mov cx,bx
DrawSquare:

    mov dl,[bp+8]
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
;---------------------------------------------   
proc SecondSquare
    push bp
    mov bp,sp
    
    mov bx,[bp+6]
    mov cx,bx
DrawFirstLine:
    mov dl,[bp+4]
    mov ah,02h
    int 21h
    loop DrawFirstLine 
    
    mov dx,[bp+8]
    mov [3],dx
    
    lea dx,[crlf] ;main problem
    mov ah,09h
    int 21h 
    
    xor cx,cx
    mov bx,[bp+6]
    mov cx,bx
    sub cx,02h
    
    push [bp+8]   
    push cx
    push [bp+6]
    push [bp+4]
    call DrawMiddle
;---------------------------------------------
proc DrawMiddle
    push bp
    mov bp,sp
    
    mov dl,[bp+4]
    mov ah,02h
    int 21h
    
    push cx

    mov cx,[bp+4]
    sub cx,2h 
DrawSpaces:
    mov dl,' '
    mov ah,02h
    int 21h
    loop DrawSpaces
    
    mov dl,[bp+4]
    mov ah,02h
    int 21h
    
    lea dx,[bp+10]
    mov ah,09h
    int 21h
    
    pop cx
    loop DrawMiddle
    mov cx,[bp+6]
       
