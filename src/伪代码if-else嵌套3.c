if (R6 != 0) {
    R6--;
}
else {
    if (R5 != 0) {
        R5--;
        goto borrow6
    }
    else {
        if (R4 != 0) {
            R4--;
            goto borrow5
        }
        else {
            if (R3 != 0) {
                R3--;
                goto borrow4
            }
            else {
                if (R2 != 0) {
                    R2--
                    goto borrow3
                }
                else {
                    if (R1 != 0) {
                        R1--
                        goto borrow2
                    }
                    else {
                        call stop()
                        call buzzer()
                    }
                }
            }
        }
    }
}
borrow2:R2 = 9;
borrow3:R3 = 5;
borrow4:R4 = 9;
borrow5:R5 = 5;
borrow6:R6 = 9;
return