if (R6 == 0) {
    if (R5 == 0) {
        if (R4 == 0) {
            if (R3 == 0) {
                if (R2 == 0) {
                    if (R1 == 0) {
                        call stop()
                        call buzzer()
                    }
                    R1--
                    goto borrow2
                }
                else {
                    R2--
                    goto borrow3
                }
            }
            else {
                R3--;
                goto borrow4
            }
        }
        else {
            R4--;
            goto borrow5
        }
    }
    else {
        R5--;
        goto borrow6
    }
}
else {
    R6--;
}
borrow2:R2 = 9;
borrow3:R3 = 5;
borrow4:R4 = 9;
borrow5:R5 = 5;
borrow6:R6 = 9;
return