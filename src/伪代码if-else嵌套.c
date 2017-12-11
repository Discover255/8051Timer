if (R6 == 0) {
    if (R5 == 0) {
        if (R4 == 0) {
            if (R3 == 0) {
                if (R2 == 0) {
                    if (R1 == 0) {
                        call stop()
                        call buzzer()
                    }
                    R1--;
                    R2 = 9;
                    R3 = 5;
                    R4 = 9;
                    R5 = 5;
                    R6 = 9;
                }
                else {
                    R2--;
                    R3 = 5;
                    R4 = 9;
                    R5 = 5;
                    R6 = 9;
                }
            }
            else {
                R3--;
                R4 = 9;
                R5 = 5;
                R6 = 9;
            }
        }
        else {
            R4--;
            R5 = 5;
            R6 = 9;
        }
    }
    else {
        R5--;
        R6 = 9;
    }
}
else {
    R6--;
}