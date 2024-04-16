data_seg		SEGMENT
        poruka1         db "Unesite broj N: $"
        strN            db "       "
        N               dw 0
        duzinaSekvence  dw ?
        poruka2         db "Magicna sekvenca za unijeto N izgleda ovako: $"
        element         dw ?
        strElement      db "       "
data_seg		ENDS
              
code_seg	    SEGMENT
        ; Pretpostavljanje vrednosti u segmentnim registrima
		ASSUME cs:code_seg, ds: data_seg

novired proc
        push ax
        push bx
        push cx
        push dx
        mov ah,03
        mov bh,0
        int 10h
        inc dh
        mov dl,0
        mov ah,02
        int 10h
        pop dx
        pop cx
        pop bx
        pop ax
        ret
novired endp

writeString macro s
        push ax
        push dx
        mov dx, offset s
        mov ah, 09
        int 21h
        pop dx
        pop ax
endm

readString proc
        push ax
        push bx
        push cx
        push dx
        push si
        mov bp, sp
        mov dx, [bp+12]
        mov bx, dx
        mov ax, [bp+14]
        mov byte [bx] ,al
        mov ah, 0Ah
        int 21h
        mov si, dx
        mov cl, [si+1]
        mov ch, 0
kopiraj:
        mov al, [si+2]
        mov [si], al
        inc si
        loop kopiraj
        mov [si], '$'
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret
readString endp  

stoi proc
        push ax
        push bx
        push cx
        push dx
        push si
        ; ucitavanje stringa
        mov bp, sp
        mov bx, [bp+14]
        ; int koji se racuna
        mov ax, 0
        mov cx, 0
        ; konstanta za pomeraj mesta u intu
        mov si, 10
petlj_stoi:
        ; upisivanje cifre iz stringa u cl
        mov cl, [bx]
        ; provera da li je kraj stringa
        cmp cl, '$'
        je kraj_stoi
        ; pomeriti cifre za jedno mesto u levo
        mul si
        ; pretvaranje ascii koda u cifru
        sub cx, 48
        ; dodavanje poslednje cifre na int
        add ax, cx
        ; prelazaka na sledecu cifru
        inc bx
        jmp petlj_stoi
kraj_stoi:
        ; upisivanje int-a na datu adresu
        mov bx, [bp+12]
        mov [bx], ax
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret 4
stoi endp

itos proc
        push ax
        push bx
        push cx
        push dx
        push si
        ; ucitavanje adrese stringa
        mov bp, sp
        mov ax, [bp+14]
        ; ubacivanje $ na stack
        ; kada se budu citale cifre (char) sa stack-a
        ; poslednja vrednost ce biti $ i to ce nam biti
        ; znak da je string procitan sa stacka
        mov dl, '$'
        push dx
        mov si, 10
petlj_itos:
        ; ostatak pri deljenu se upisuje u dx
        mov dx, 0
        div si
        ; pretvaranje u karakter broja
        add dx, 48
        push dx
        ; da li je int nula (ako jeste onda je konverzija gotova)
        cmp ax, 0
        jne petlj_itos
        
        ; ucitavnaje adrese stringa
        mov bx, [bp+12]
petlja_itos:
        ; skidanje cifre (char) sa stack-a i upisivanje u string
        pop dx
        mov [bx], dl
        inc bx
        ; ako je poslednji upisani karakter $ onda je string gotov
        cmp dl, '$'
        jne petlja_itos
        
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret 4
itos endp

; makro koji racuna 2^n
; to predstavlja broj elemenata u sekvenci 
; izracunatu vrijednost cuva u duzinaSekvence
dva_na_n macro br
        push bx
        
        ; u duzinaSekvence se upisuje 2 koje ce se siftovati i tako mnoziti sa 2 u svakoj iteraciji
        mov duzinaSekvence, 2
        ; bx je counter koji ce se smanjivati od proslijedjenog broja do 1              
        mov bx, br
    
loop_start:
        ; provjera da li je bx 1
        cmp bx, 1
        ; ako jeste, izlazi se iz petlje               
        je loop_end            
        
        ; inace, duzinaSekvence se siftuje lijevo za 1 i time mnozi sa 2
        shl duzinaSekvence, 1
        ; brojac se smanjuje za 1              
        dec bx
        ; povratak na pocetak petlje                  
        jmp loop_start          

loop_end:
        pop bx
ENDM

        ; Podesavamo DATA segment
start:  lea dx, data_seg
        mov ds, dx  
        
        ; ispisivanje
        writeString poruka1
        push 6
        push offset strN
        call readString
        push offset strN
        push offset N
        call stoi
        call novired
        writeString poruka2
        call novired
        
        dva_na_n N  ; nakon ovoga je sacuvana duzina sekvence koja se treba stampati u duzinaSekvence
        
        ; glavna petlja koja ide od 0 do duzinaSekvene
        ; element = (brojac ^ (brojac >> 1> - tako se racuna vrijednost svakog elementa u sekvenci
        
        mov cx, 0
        
loop1:  
        ; provjera da li je petlja dosla do kraja
        cmp cx, duzinaSekvence
        ; ako jeste, izlazimo iz nje
        je loop1end 
        
        ; kopiranje vrijednosti brojaca da bi se koristila pri racunanju
        mov dx, cx             
        
        ; siftovanje te vrijednosti za jedan bit
        shr dx, 1
        ; bitwise xor izmedju siftovanog brojaca i originalnog brojaca               
        xor dx, cx              
        
        ; vrijednost izracunatog elementa se upisuje u element
        mov element, dx             
                
        ; stampanje elementa
        push element
        lea bx, strElement
        push bx
        call itos
        writeString strElement
        call novired    
        
        ; povecavanje brojaca
        inc cx
        ; povratak na pocetak petlje                  
        jmp loop1
            
loop1end:        

kraj:   jmp kraj

code_seg        ENDS
END start  

