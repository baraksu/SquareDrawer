 ;version 108 
.MODEL small
.STACK 100h
.DATA
length db 0
char db 0
crlf db 13,10,'$'
msg1 db 13,10,'please enter the square length',13,10,'$'
msg2 db 13,10,'please enter the char',13,10,'$'
msg3 db 13,10,'the full square: ',13,10,'$'
msg4 db 13,10,'the empty square: ',13,10,'$'
msg5 db 13,10,'that was my projact hope you like it!,please hit any key to exit',13,10,'$'
msg6 db 13,10,'press: a for full square,b for empty square, and e to exit: ',13,10,'$'
msg7 db 13,10,'invalid input.',13,10,'$' 
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
    xor bh,bh
    mov bl,[length] 
    
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
    xor bh,bh
    mov [length],bl
    mov [char],cl
    mov [crlf],dl
    push dx
    push bx
    xor ch,ch
    push cx
    mov [crlf],dl
    
    cmp bl,10
    jb OneDigit
    call TdFirstSquare
    jmp start
OneDigit:    
    call OdFirstSquare
    jmp start
    
Square2: 

    push offset length
    call GetLength
    cmp al,2
    jbe InvalidInput
    
    xor bh,bh
    mov bl,[length] 
    
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
    
    cmp bx,10
    jb OneDigit1
    call TdSecondSquare
    jmp start
OneDigit1:    
    call OdSecondSquare
    jmp start
     
InvalidInput:
    call invalid
    jmp start   
    
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
    
    lea dx, msg1
    mov ah,09h
    int 21h    

    xor ax,ax
    xor bx,bx    

    
    mov ah,01h
    int 21h  
    sub al,30h 
    cmp al,0
    jb InvalidInput    
    cmp al,9
    ja InvalidInput
    xor cx,cx
    
    mov bl,al
    mov cl,10h
    mul cl 
    mov bl,al
    
    xor ax,ax
    
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
proc TdFirstSquare
    push bp
    mov bp,sp
      
    mov cx,[bp+6]
    sub cx,6h
FillSquare:   
    push cx
    mov cx,bx
    sub cx,6h
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
proc TdSecondSquare
   push bp
   mov bp,sp
   
   mov bx,[bp+4]
   mov cx,bx
   sub cx,6h
   
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
    sub cx,8h
DrawMiddle:
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    
    push cx
    
    mov cx,bx
    sub cx,8h
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
    sub cx,6h
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
;---------------------------------------------
;proc 6
proc invalid
    lea dx,msg7
    mov ah,09h
    int 21h
    
    ret
endp invalid
;---------------------------------------------
;proc 7
 proc OdFirstSquare
    push bp
    mov bp,sp  
    
    mov cx,[bp+6]

FillSquare1:   
    push cx
    mov cx,bx

DrawSquare1:
          
    mov dl,[bp+4]
    mov ah,02h
    int 21h  
    loop DrawSquare1
    
    lea dx,[crlf]
    mov ah,09h
    int 21h 
    pop cx
    loop FillSquare1 
    
    pop bp
    ret 8
endp OdFirstSquare


;---------------------------------------------
;proc 8
   proc OdSecondSquare
   push bp
   mov bp,sp
   
   mov bx,[bp+4]
   mov cx,bx
   
DrawFirstLine1:
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    loop DrawFirstLine1
    mov dx,[bp+8]
    mov [crlf],dl
    
    lea dx,[crlf]
    mov ah,09h
    int 21h
    
    xor cx,cx
    mov cx,bx
    sub cx,2h
DrawMiddle1:
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    
    push cx
    
    mov cx,bx
    sub cx,2h
DrawSpaces1:
    mov dl,' '
    mov ah,02h
    int 21h
    loop DrawSpaces1
    
    
    mov dl,[bp+6]
    mov ah,02h
    int 21h
    
    lea dx,[crlf]
    mov ah,09h
    int 21h
    pop cx
    loop DrawMiddle1
    mov cx,bx
DrawLastLine1:
    mov dl,char
    mov ah,02h
    int 21h
    loop DrawLastLine1
    
    pop bp
    ret 6
endp OdFirstSquare
;---------------------------------------------
;proc 9
proc EndProgram   
    mov ah,01h
    int 21h
 
    mov ah,4Ch
    int 21h
    endp EndProgram
END     