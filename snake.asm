org 0x0100
jmp start

; Data Section
direction: db 3
speed: dw 1

food_row: db 5
food_col: db 10
food_exists: db 1
seed: dw 0

max_len equ 100
snake_length db 1
snake_x times max_len db 0
snake_y times max_len db 0

score: dw 0
score_text db "SCORE: ", 0

snake_title db "SNAKE GAME", 0
start_text db "START: S EXIT: E", 0
game_over_text db "GAME OVER", 0
restart_msg db "RESTART: R EXIT: E", 0
final_score_msg db "Your Final Score is: ", 0


clrscr:
    push ax
    push cx
    push di
    push es
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov cx, 2000
    mov ax, 0x0720
    rep stosw
    pop es
    pop di
    pop cx
    pop ax
    ret

print_string:
    push ax
    push bx
    push si
    push di
    push es

    mov ax, 0xb800
    mov es, ax

    ; Calculate screen offset
    mov al, dh
    mov bl, 80
    mul bl
    add al, dl
    adc ah, 0
    shl ax, 1
    mov di, ax

next_char:
    lodsb
    cmp al, 0
    je done_print
    mov ah, bh    
    stosw
    jmp next_char

done_print:
    pop es
    pop di
    pop si
    pop bx
    pop ax
    ret


print_score:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es
   
    mov ax, 0xb800
    mov es, ax
   
    ; Position (row 0, column 70)
    mov al, 0
    mov bl, 80
    mul bl
    add al, 70
    adc ah, 0
    shl ax, 1
    mov di, ax
   
    ; Print "SCORE: " in bright white
    mov si, score_text
    mov ah, 0x0F
print_score_label:
    lodsb
    test al, al
    jz print_score_value
    stosw
    jmp print_score_label
   
print_score_value:
    ; Print score digits in bright white
    mov ax, [score]
    mov bx, 10
    xor cx, cx
   
extract_digit:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz extract_digit
   
print_digits:
    pop ax
    mov ah, 0x0F
    stosw
    loop print_digits
   
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

Snake_Printing:
    push ax
    push bx
    push cx
    push si
    push di
    push es
    mov ax, 0xb800
    mov es, ax
    xor si, si
    mov cl, [snake_length]
    xor ch, ch
print_loop:
    mov al, [snake_y + si]
    mov bl, 80
    mul bl
    add al, [snake_x + si]
    adc ah, 0
    shl ax, 1
    mov di, ax
    mov ax, 0x0A2A
    stosw
    inc si
    loop print_loop
    pop es
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret

print_food:
    cmp byte [food_exists], 0
    je done_print_food
    push ax
    push bx
    push di
    push es
    mov ax, 0xb800
    mov es, ax
    mov al, [food_row]
    mov bl, 80
    mul bl
    add al, [food_col]
    adc ah, 0
    shl ax, 1
    mov di, ax
    mov ax, 0x0C40
    stosw
    pop es
    pop di
    pop bx
    pop ax
done_print_food:
    ret

generate_seed:
    push ax
    push dx
    mov ah, 00h
    int 1Ah
    mov [seed], dx
    pop dx
    pop ax
    ret

random:
    push ax
    push dx
    mov ax, [seed]
    mov dx, 25173
    mul dx
    add ax, 13849
    mov [seed], ax
    pop dx
    pop ax
    ret

generate_food:
    call random
    mov ax, [seed]
    and ax, 0x00FF
    mov bl, 20    
    xor ah, ah
    div bl
    add ah, 2    
    mov [food_row], ah

    call random
    mov ax, [seed]
    and ax, 0x00FF
    mov bl, 75      
    xor ah, ah
    div bl
    add ah, 2      
    mov [food_col], ah

    mov byte [food_exists], 1
    ret

check_food_collision:
    mov al, [food_col]
    cmp al, [snake_x]
    jne food_check_done
    mov al, [food_row]
    cmp al, [snake_y]
    jne food_check_done
    inc word [score]
    mov al, [snake_length]
    cmp al, max_len
    jge no_increase
    inc byte [snake_length]
no_increase:
    mov byte [food_exists], 0
    call generate_food
food_check_done:
    ret

printBoundary:
    push ax
    push bx
    push cx
    push di
    push es
    mov ax, 0xb800
    mov es, ax
    mov di, 160
    mov cx, 80
    mov ax, 0x1920  ; Blue background with space
top_loop:
    stosw
    loop top_loop
    mov di, 24*80*2
    mov cx, 80
bottom_loop:
    stosw
    loop bottom_loop
    mov bx, 1
side_loop:
    mov di, bx
    imul di, 160
    mov [es:di], ax
    add di, 158
    mov [es:di], ax
    inc bx
    cmp bx, 24
    jl side_loop
    pop es
    pop di
    pop cx
    pop bx
    pop ax
    ret

delay:
    push cx
    push dx
    mov cx, [speed]
outer:
    mov dx, 0xFFFF
inner:
    nop
    dec dx
    jnz inner
    loop outer
    pop dx
    pop cx
    ret

read_input:
    mov ah, 1
    int 0x16
    jz no_input
    mov ah, 0
    int 0x16
    cmp ah, 0x48
    je set_up
    cmp ah, 0x50
    je set_down
    cmp ah, 0x4B
    je set_left
    cmp ah, 0x4D
    je set_right
no_input:
    ret

set_up:
    cmp byte [direction], 1
    je no_input
    mov byte [direction], 0
    jmp no_input

set_down:
    cmp byte [direction], 0
    je no_input
    mov byte [direction], 1
    jmp no_input

set_left:
    cmp byte [direction], 3
    je no_input
    mov byte [direction], 2
    jmp no_input

set_right:
    cmp byte [direction], 2
    je no_input
    mov byte [direction], 3
    jmp no_input

check_self_collision:
    push ax
    push bx
    push cx
    push si
   
    mov al, [snake_length]
    cmp al, 5
    jb no_collision
   
    mov bl, [snake_x]
    mov bh, [snake_y]
   
    mov si, 4
    mov cl, [snake_length]
    dec cl
   
check_loop:
    cmp bl, [snake_x + si]
    jne next_segment
    cmp bh, [snake_y + si]
    je game_over
   
next_segment:
    inc si
    cmp si, cx
    jb check_loop
   
no_collision:
    pop si
    pop cx
    pop bx
    pop ax
    ret

check_boundary:
    cmp byte [snake_x], 1
    jbe game_over
    cmp byte [snake_x], 78
    jae game_over
    cmp byte [snake_y], 1
    jbe game_over
    cmp byte [snake_y], 24
    jae game_over
    ret

game_over:
    call clrscr

    ; Print Game Over
    mov si, game_over_text
    mov dh, 12
    mov dl, 35
    mov bh, 0x04
    call print_string

    ; Print Restart Message
    mov si, restart_msg
    mov dh, 16
    mov dl, 30
    mov bh, 0x0F
    call print_string

    ; Print Final Score Message
    mov si, final_score_msg
    mov dh, 14
    mov dl, 28
    mov bh, 0x0F
    call print_string

    ; Now set cursor for score digits
    mov ax, 0xb800
    mov es, ax

    ; calculate offset
    mov al, dh
    mov bl, 80
    mul bl
    add al, dl
    adc ah, 0
    shl ax, 1
    add ax, 42       ; <<< corrected offset (19 chars * 2 bytes = 38 bytes)
    mov di, ax

    ; Print actual score
    mov ax, [score]
    mov bx, 10
    xor cx, cx

print_score_digits:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz print_score_digits

print_digits_final:
    pop ax
    mov ah, 0x0F
    stosw
    loop print_digits_final

wait_key:
    mov ah, 0
    int 0x16
    cmp al, 'R'
    je restart_game
    cmp al, 'r'
    je restart_game
    cmp al, 'E'
    je exit_game
    cmp al, 'e'
    je exit_game
    jmp wait_key




restart_game:
    mov word [score], 0
    jmp continue

exit_game:
    mov ax, 0x4c00
    int 0x21

start:
    call clrscr
    mov si, snake_title
    mov dh, 10
    mov dl, 35
mov bh, 0x0A
    call print_string
    mov si, start_text
    mov dh, 12
    mov dl, 33
mov bh,0x0F
    call print_string
wait_start:
    mov ah, 0
    int 0x16
    cmp al, 'S'
    je continue
    cmp al, 's'
    je continue
    cmp al, 'E'
    je exit_game
    cmp al, 'e'
    je exit_game
    jmp wait_start

continue:
    call clrscr
    call generate_seed
    mov byte [snake_length], 1
    mov byte [snake_x], 40
    mov byte [snake_y], 12
    mov byte [direction], 3
    mov word [score], 0
    call generate_food

main_loop:
    mov dx, 0x03DA
wait_vrt:
    in al, dx
    test al, 8
    jz wait_vrt
    call clrscr
    call printBoundary
    call print_score
    call Snake_Printing
    call print_food
    call delay
    call read_input
    call check_food_collision
    mov dl, [snake_x]
    mov dh, [snake_y]
    cmp byte [direction], 0
    je move_up
    cmp byte [direction], 1
    je move_down
    cmp byte [direction], 2
    je move_left
    cmp byte [direction], 3
    je move_right

move_up:
    mov word [speed], 3
    dec dh
    jmp move_check
move_down:
    mov word [speed], 3
    inc dh
    jmp move_check
move_left:
    mov word [speed], 1
    dec dl
    jmp move_check
move_right:
    mov word [speed], 1
    inc dl

move_check:
    call check_boundary
    call check_self_collision
    movzx si, byte [snake_length]
    dec si
    jz update_head

update_body:
    mov al, [snake_x + si - 1]
    mov [snake_x + si], al
    mov al, [snake_y + si - 1]
    mov [snake_y + si], al
    dec si
    jnz update_body

update_head:
    mov [snake_x], dl
    mov [snake_y], dh
    jmp main_loop