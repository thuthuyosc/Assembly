; DO AN MON HE THONG MAY TINH
; GIANG VIEN: THAI HUNG VAN
; HK2 NAM 2021-2022

; NGUYEN HUU PHUC	20120161
; HOANG THU THUY	20120382

;----------------------------SOURCE CODE----------------------------


.model small
.stack	100h
.data
	tb_capslock db "Caps Lock status: $"
	tb_scrolllock db "Scroll Lock status: $"
	tb_gio db "Time now: $"
	tb_nhapchuoi db "Enter string: $"
	tb_chuhoa db "Uppercase : $"
	tb_chuthuong db "Lowercase : $"
	string db 81 dup ('$')			; first byte is maximum characters (80 chars + return) | second byte is real string length
	tb_nhapso db "Enter integer: $"
	tb_tong db "Sum of 2 integers: $"
	tb_hieu db "Difference of 2 integers: $"
	tb_tich db "Product of 2 integers: $"
	tb_thuong db "Quotient of 2 integers: $"
	tb_sodu db "Remainder: $"
	tb_buoisang db "Good Morning !$"
	tb_buoichieu db "Good Afternoon !$"
	tb_buoitoi db "Good Evening !$"

	x dw ? ; luu gia tri 2 chu so nhap vao
	y dw ?
	num1 dw ?
	num2 dw ?
	
.code

;-----------------------------------------------------------------
;-------------------Utility Function------------------------------
;-----------------------------------------------------------------
	
	;-----print string in DX-----
printDX	proc
	push	ax
	mov	ah, 9h
	int 	21h
	pop 	ax 
	ret    
printDX endp


	;-----end line-----
endl proc
	push	ax
	push	dx

	mov 	dl, 10d
	mov	ah, 2h
	int 	21h

	mov 	dl, 13d
	mov	ah, 2h
	int 	21h

	pop 	dx
	pop 	ax 
	ret  
endl endp


	;-----input integer-----
inputInteger proc
	push  	 bx
	push 	 ax

	mov	 x, 0
	mov 	 y, 0
	mov 	 bx, 10
input:
	mov 	ah, 1
	int 	21h
	
	cmp 	al, 13 		; if press "Enter" -> exit
	je exit

	sub 	al,30h 		; sub al for '0' to get an integer
	xor 	ah,ah 		; empty ah before using ax (just need data in al)
	mov 	y, ax
	mov 	ax, x
	mul 	bx
	add 	ax, y
	mov 	x, ax
	jmp input
exit:
	pop 	ax
	pop 	bx
	ret
inputInteger endp


	;-----print integer-----
printInteger proc
	push	ax
	push 	bx
    	push 	cx
    	push 	dx 

	mov	bx, 10
	mov 	cx, 0 		; count var
divide:
	mov 	dx, 0
	div	bx
	inc 	cx; cx++
	push 	dx 		; save the remainder
	cmp	ax, 0
	je 	print
	jmp	divide
print:
	pop 	dx 		; get the remainder and print it
	add	dl,30h
	mov 	ah,2
	int	21h
	dec 	cx
	cmp 	cx, 0
	jne	print
	jmp 	printEnd
printEnd:
	pop 	dx
   	pop 	cx
	pop 	bx
   	pop 	ax
	ret
printInteger endp

;-----------------------------------------------------------------
;---------------------SOLVE FUCTION-------------------------------
;-----------------------------------------------------------------

	;-----Question 1-----

YeuCau1_HienThiGio proc
	push 	dx
	push 	ax
	push 	cx

	lea	dx, tb_gio	; print massage
	call	printDX

	mov 	ah, 2ch		; get system time
	int 	21h		; hour-ch  min-cl  sec-dh	
	push 	dx
	push 	cx	

	mov	al, ch 		; print hour
	mov	ah, 0
	call 	printInteger
	
	mov 	ah, 2
	mov 	dl, ':'
	int 	21h

	pop	cx		; print minute
	mov 	al, cl
	mov	ah, 0
	call 	printInteger

	mov 	ah, 2
	mov 	dl, ':'
	int 	21h

	pop	dx		; print second
	mov 	al, dh
	mov 	ah, 0
	call 	printInteger
	
	call 	endl
	
	pop	cx
	pop 	ax
	pop 	dx
	ret
YeuCau1_HienThiGio endp


	;-----Question 2-----

YeuCau2_HienThiChuoiInHoa proc
	push	dx
	
	lea	dx, tb_nhapchuoi		; print message 
	call	printDX
	
	lea	dx, string			; get input
	mov 	ah, 10
	int 	21h
	
uppercase:
	call	endl
	lea	dx, tb_chuhoa			; uppercase
	call	printDX

	lea	si, string+2

	gothroughstring: 
		mov	dl, [si]
	
		cmp	dl, 'a'			; if ASCII < a then print
		jl	printChar

		cmp 	dl, 'z'			; if ASCII > z then print
		jg	printChar

		sub	dl, 32			; else uppercase by minus 32
	printChar:
		mov 	ah, 2			; print char
		int 	21h

		inc	si
		mov	dl, [si]
		cmp 	dl, '$'
		jne	gothroughstring
		
		call	endl
		jmp 	lowercase
lowercase:
	lea	dx, tb_chuthuong
	call	printDX

	lea	si, string+2

	gothroughstring2: 
		mov	dl, [si]
	
		cmp	dl, 'A'			; if ASCII < A then print
		jl	printChar2

		cmp 	dl, 'Z'			; if ASCII > Z then print
		jg	printChar2

		add	dl, 32			; else uppercase by add 32
	printChar2:
		mov 	ah, 2			; print char
		int 	21h

		inc	si
		mov	dl, [si]
		cmp 	dl, '$'			; continue until end of string
		jne	gothroughstring2
		
		call	endl

exit_q2:
	pop	dx
	ret
YeuCau2_HienThiChuoiInHoa endp


	;-----Question 3-----

YeuCau3_TinhToanSo2ChuSo proc
	lea 	dx, tb_nhapso			; input num1
	call	printDX

	call 	inputInteger
	push 	ax
	mov 	ax, x
	mov 	num1, ax
	pop	ax
	
	lea 	dx, tb_nhapso			; input num2
	call	printDX

	call 	inputInteger
	push	ax
	mov 	ax, x
	mov	num2, ax
	pop	ax

TinhTong:	
	lea 	dx, tb_tong
	call	printDX

	push 	ax

	mov	ax, num1
	add 	ax, num2

	call 	printInteger
	call 	endl
	
	pop 	ax

TinhHieu:
	lea	dx, tb_hieu
	call	printDX
	
	push 	ax
	push 	dx	

	mov	ax, num1
	mov	dx, num2
	cmp	ax, dx
	jl	HieuSoAm 			; num1 < num2

	sub	ax, dx				; num1 >= num2
	call	printInteger	

	pop	dx
	pop	ax

	call 	endl

	jmp 	Tich	

HieuSoAm:
	sub	dx, ax
	mov 	ax, dx
	
	push	ax
	
	mov	ah, 2h
	mov	dl, '-'
	int 	21h
	
	pop	ax
	
	call printInteger
	call 	endl

	pop	dx
	pop	ax	
	
	jmp 	Tich
	
Tich:	
	lea 	dx, tb_tich
	call	printDX
	
	push	ax
	
	mov	ax, num1
	mov 	bx, num2
	mul	bx
	
	call 	printInteger
	call 	endl

	pop	ax
Thuong:
	lea	dx, tb_thuong
	call	printDX
	
	push 	ax
	push	bx
		
	mov 	dx, 0				; dx is remainder
	mov 	ax, num1
	mov 	bx, num2
	div	bx	
	call 	printInteger			; print ax
	
	push	dx

	mov 	ah, 2h
	mov	dl, ' '
	int 	21h	

	lea 	dx, tb_sodu			; print remainder
	call 	printDX	

	pop	dx

	mov 	ax, dx
	call	printInteger
	call	endl	

	pop 	bx
	pop 	ax
	
exit_q3:
	ret
YeuCau3_TinhToanSo2ChuSo endp


	;-----Question 4-----

YeuCau4_HienThiLoiChao proc
	push	ax
	push 	cx	

	mov 	ah, 2ch		; get time: hour-ch
	int 	21h	
	
	cmp 	ch, 12
	jl	ChaoBuoiSang	

	cmp 	ch, 18
	jl	ChaoBuoiChieu	

	cmp 	ch, 24		
	jl 	ChaoBuoiToi	

ChaoBuoiSang:
	lea 	dx, tb_buoisang
	call	printDX
	call	endl	

	jmp	exit_q4

ChaoBuoiChieu:
	lea 	dx, tb_buoichieu
	call	printDX
	call	endl	

	jmp	exit_q4

ChaoBuoiToi:
	lea 	dx, tb_buoitoi
	call	printDX
	call	endl	

	jmp	exit_q4

exit_q4:
	pop	cx
	pop 	ax
	ret
YeuCau4_HienThiLoiChao endp

;---------------------------------------------------
main	proc
	
	; load ds 
    	mov 	ax, @data
	mov	ds, ax

	; get shift status
	mov 	ah, 02h
	int 	16h
	
	cmp	al, 01000000b 		; capslock on, scrolllock off
	je	CapsLockOn

	cmp	al, 00010000b 		; capslock off, scrolllock on
	je	ScrollLockOn

	cmp	al, 00000000b		; both lights off
	je	BothOff

	cmp	al, 01010000b		; both lights on
	je 	BothOn

CapsLockOn:
	lea 	dx, tb_capslock			; print Caps Lock status
	call	printDX
	mov	dl, '1'
	mov 	ah, 2h
	int 	21h
	call 	endl

	lea 	dx, tb_scrolllock		; print Scroll Lock status		
	call	printDX
	mov	dl, '0'
	mov 	ah, 2h
	int 	21h
	call 	endl

	call	YeuCau2_HienThiChuoiInHoa
	jmp	finish

ScrollLockOn:
	lea 	dx, tb_capslock			; print Caps Lock status
	call	printDX
	mov	dl, '0'
	mov 	ah, 2h
	int 	21h
	call 	endl

	lea 	dx, tb_scrolllock		; print Scroll Lock status		
	call	printDX
	mov	dl, '1'
	mov 	ah, 2h
	int 	21h
	call 	endl

	call 	YeuCau3_TinhToanSo2ChuSo
	jmp 	finish

BothOff:
	lea 	dx, tb_capslock			; print Caps Lock status
	call	printDX
	mov	dl, '0'
	mov 	ah, 2h
	int 	21h
	call 	endl

	lea 	dx, tb_scrolllock		; print Scroll Lock status		
	call	printDX
	mov	dl, '0'
	mov 	ah, 2h
	int 	21h
	call 	endl

	call 	YeuCau4_HienThiLoiChao
	jmp 	finish

BothOn:
	lea 	dx, tb_capslock			; print Caps Lock status
	call	printDX
	mov	dl, '1'
	mov 	ah, 2h
	int 	21h
	call 	endl

	lea 	dx, tb_scrolllock		; print Scroll Lock status		
	call	printDX
	mov	dl, '1'
	mov 	ah, 2h
	int 	21h
	call 	endl

	call 	YeuCau1_HienThiGio
	jmp	finish

finish:	
	mov	ax, 4c00h
	int	21h

main	endp
end	main	