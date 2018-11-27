;print newline
mov ah,2h
mov dl,10
intt 21h

;input
mov ah,1h
int 21h
read into => al

;print 
mov ah,2h
mov dl, 'val'
int 21h

;print str
lea dx, msgg
mov ah,9h
int 21h

;passwd input
mov ah,8h
int 21h
read into al


;mul16
ax, a
bx, b
mul bx

stored => ax= ax*bx
aam roll ah into ah,al

;end
mov ah, 4ch
int 21h
end





.model small
.data
	s1 db 'crapped'
	s1len dw $-s1
	err db 'not pal$'
	done db 'equal$'
	srev db 20 dup(' ')

.code
	mov ax, @data
	mov ds, ax

	mov si, offset s1
	mov di, offset srev
	
	add si, s1len
	add si, -1

	mov cx, s1len
	add cx, -1
	cpy:
		mov al, [si]
		mov [di], al
		inc di
		dec si
		loop cpy
		
		dec cx
		cmp cx, 0
		jg cpy

		mov al, [si]
		mov [di], al
		;inc di
		;mov dl, '$'
		;mov [di], dl
	
	;printer:
	;	lea dx, srev
	;	mov ah, 9h
	;	int 21h

	mov si, offset s1	
	mov di, offset srev
	mov cx, s1len

	check:
		mov ax, [si]
		cmp ax, [di]
		
		mov ah,2h
		mov dl, [si]
		int 21h
		mov ah,2h
		mov dl, ' '
		int 21h
		mov ah,2h
		mov dl, [di]
		int 21h
		mov ah,2h
		mov dl, 10
		int 21h

		jg fail
		
		inc si
		inc di
		dec cx
		cmp cx, 0
		jg check

		jmp finn

	
	finn:
		lea dx, done
		mov ah,9h
		int 21h
		jmp ex
	fail:
		lea dx, err
		mov ah,9h
		int 21h
		
	ex:
		mov ah, 4ch
		int 21h
		end

