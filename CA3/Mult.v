module mult (input [7:0] D1 ,input [7:0] D2 , output [15:0] out);
	wire w10 , w20 , w30 , w40 , w50 , w60 , w70;
	And and00(.a(D1[0]) , .b(D2[0]) , .out(out[0]));
	And and10(.a(D1[1]) , .b(D2[0]) , .out(w10) );
	And and20(.a(D1[2]) , .b(D2[0]) , .out(w20) );
	And and30(.a(D1[3]) , .b(D2[0]) , .out(w30) );
	And and40(.a(D1[4]) , .b(D2[0]) , .out(w40) );
	And and50(.a(D1[5]) , .b(D2[0]) , .out(w50) );
	And and60(.a(D1[6]) , .b(D2[0]) , .out(w60) );
	And and70(.a(D1[7]) , .b(D2[0]) , .out(w70) );



	wire w01 , w11 , w21 , w31 , w41 , w51 , w61 , w71 ;
	And and01(.a(D1[0]) , .b(D2[1]) , .out(w01));
	And and11(.a(D1[1]) , .b(D2[1]) , .out(w11));
	And and21(.a(D1[2]) , .b(D2[1]) , .out(w21));
	And and31(.a(D1[3]) , .b(D2[1]) , .out(w31));
	And and41(.a(D1[4]) , .b(D2[1]) , .out(w41));
	And and51(.a(D1[5]) , .b(D2[1]) , .out(w51));
	And and61(.a(D1[6]) , .b(D2[1]) , .out(w61));
	And and71(.a(D1[7]) , .b(D2[1]) , .out(w71));


	wire c10 , c11 , c12 , c13 , c14 , c15 , c16 , c17 , s11 , s12 , s13 , s14 , s15 , s16 , s17 ;
	FA fa01(.A(w01),.B(w10) , .Cin(1'b0) , .Sum(out[1]) , .Cout(c10));
	FA fa11(.A(w11),.B(w20) , .Cin(c10) , .Sum(s11) , .Cout(c11));
	FA fa21(.A(w21),.B(w30) , .Cin(c11) , .Sum(s12) , .Cout(c12));
	FA fa31(.A(w31),.B(w40) , .Cin(c12) , .Sum(s13) , .Cout(c13));
	FA fa41(.A(w41),.B(w50) , .Cin(c13) , .Sum(s14) , .Cout(c14));
	FA fa51(.A(w51),.B(w60) , .Cin(c14) , .Sum(s15) , .Cout(c15));
	FA fa61(.A(w61),.B(w70) , .Cin(c15) , .Sum(s16) , .Cout(c16));
	FA fa71(.A(w71),.B(1'b1) , .Cin(c16) , .Sum(s17) , .Cout(c17));


	wire w02 , w12 , w22 , w32 , w42 , w52 , w62 , w72;
	And and02(.a(D1[0]) , .b(D2[2]) , .out(w02));
	And and12(.a(D1[1]) , .b(D2[2]) , .out(w12) );
	And and22(.a(D1[2]) , .b(D2[2]) , .out(w22) );
	And and32(.a(D1[3]) , .b(D2[2]) , .out(w32) );
	And and42(.a(D1[4]) , .b(D2[2]) , .out(w42) );
	And and52(.a(D1[5]) , .b(D2[2]) , .out(w52) );
	And and62(.a(D1[6]) , .b(D2[2]) , .out(w62) );
	And and72(.a(D1[7]) , .b(D2[2]) , .out(w72) );

	wire c20 , c21 , c22 , c23 , c24 , c25 , c26 , c27 , s21 , s22 , s23 , s24;
	FA fa02(.A(w02),.B(s11) , .Cin(1'b0) , .Sum(out[2]) , .Cout(c20));
	FA fa12(.A(w12),.B(s12) , .Cin(c20) , .Sum(s21) , .Cout(c21));
	FA fa22(.A(w22),.B(s13) , .Cin(c21) , .Sum(s22) , .Cout(c22));
	FA fa32(.A(w32),.B(s14) , .Cin(c22) , .Sum(s23) , .Cout(c23));
	FA fa42(.A(w42),.B(s15) , .Cin(c23) , .Sum(s24) , .Cout(c24));
	FA fa52(.A(w52),.B(s16) , .Cin(c24) , .Sum(s25) , .Cout(c25));
	FA fa62(.A(w62),.B(s17) , .Cin(c25) , .Sum(s26) , .Cout(c26));
	FA fa72(.A(w72),.B(c17) , .Cin(c26) , .Sum(s27) , .Cout(c27));


	wire w03 , w13 , w23 , w33 , w43 , w53 , w63 , w73;
	And and03(.a(D1[0]) , .b(D2[3]) , .out(w03));
	And and13(.a(D1[1]) , .b(D2[3]) , .out(w13) );
	And and23(.a(D1[2]) , .b(D2[3]) , .out(w23) );
	And and33(.a(D1[3]) , .b(D2[3]) , .out(w33) );
	And and43(.a(D1[4]) , .b(D2[3]) , .out(w43) );
	And and53(.a(D1[5]) , .b(D2[3]) , .out(w53) );
	And and63(.a(D1[6]) , .b(D2[3]) , .out(w63) );
	And and73(.a(D1[7]) , .b(D2[3]) , .out(w73) );


	wire c30 , c31 , c32 , c33 , c34 , c35 , c36 , c37, s31 , s32 , s33 , s34 , s35 , s36 , s37 ;
	FA fa03(.A(w03),.B(s21) , .Cin(1'b0) , .Sum(out[3]) , .Cout(c30));
	FA fa13(.A(w13),.B(s22) , .Cin(c30) , .Sum(s31) , .Cout(c31));
	FA fa23(.A(w23),.B(s23) , .Cin(c31) , .Sum(s32) , .Cout(c32));
	FA fa33(.A(w33),.B(s24) , .Cin(c32) , .Sum(s33) , .Cout(c33));
	FA fa43(.A(w43),.B(s25) , .Cin(c33) , .Sum(s34) , .Cout(c34));
	FA fa53(.A(w53),.B(s26) , .Cin(c34) , .Sum(s35) , .Cout(c35));
	FA fa63(.A(w63),.B(s27) , .Cin(c35) , .Sum(s36) , .Cout(c36));
	FA fa73(.A(w73),.B(c27) , .Cin(c36) , .Sum(s37) , .Cout(c37));

	//4
	wire w04 , w14 , w24 , w34 , w44 , w54 , w64 , w74;
	And and04(.a(D1[0]) , .b(D2[4]) , .out(w04));
	And and14(.a(D1[1]) , .b(D2[4]) , .out(w14) );
	And and24(.a(D1[2]) , .b(D2[4]) , .out(w24) );
	And and34(.a(D1[3]) , .b(D2[4]) , .out(w34) );
	And and44(.a(D1[4]) , .b(D2[4]) , .out(w44) );
	And and54(.a(D1[5]) , .b(D2[4]) , .out(w54) );
	And and64(.a(D1[6]) , .b(D2[4]) , .out(w64) );
	And and74(.a(D1[7]) , .b(D2[4]) , .out(w74) );


	wire c40 , c41 , c42 , c43 , c44 , c45 , c46, c47 , s41 , s42 , s43 , s44 , s45 , s46 , s47 ;
	FA fa04(.A(w04),.B(s31) , .Cin(1'b0) , .Sum(out[4]) , .Cout(c40));
	FA fa14(.A(w14),.B(s32) , .Cin(c40) , .Sum(s41) , .Cout(c41));
	FA fa24(.A(w24),.B(s33) , .Cin(c41) , .Sum(s42) , .Cout(c42));
	FA fa34(.A(w34),.B(s34) , .Cin(c42) , .Sum(s43) , .Cout(c43));
	FA fa44(.A(w44),.B(s35) , .Cin(c43) , .Sum(s44) , .Cout(c44));
	FA fa54(.A(w54),.B(s36) , .Cin(c44) , .Sum(s45) , .Cout(c45));
	FA fa64(.A(w64),.B(s37) , .Cin(c45) , .Sum(s46) , .Cout(c46));
	FA fa74(.A(w74),.B(c37) , .Cin(c46) , .Sum(s47) , .Cout(c47));


	//5
	wire w05 , w15 , w25 , w35 , w45 , w55 , w65 , w75;
	And and05(.a(D1[0]) , .b(D2[5]) , .out(w05));
	And and15(.a(D1[1]) , .b(D2[5]) , .out(w15) );
	And and25(.a(D1[2]) , .b(D2[5]) , .out(w25) );
	And and35(.a(D1[3]) , .b(D2[5]) , .out(w35) );
	And and45(.a(D1[4]) , .b(D2[5]) , .out(w45) );
	And and55(.a(D1[5]) , .b(D2[5]) , .out(w55) );
	And and65(.a(D1[6]) , .b(D2[5]) , .out(w65) );
	And and75(.a(D1[7]) , .b(D2[5]) , .out(w75) );


	wire c50 , c51 , c52 , c53 , c54 , c55 , c56, c57 , s51 , s52 , s53 , s54 , s55 , s56 , s57 ;
	FA fa04(.A(w05),.B(s41) , .Cin(1'b0) , .Sum(out[5]) , .Cout(c50));
	FA fa14(.A(w15),.B(s42) , .Cin(c50) , .Sum(s51) , .Cout(c51));
	FA fa24(.A(w25),.B(s43) , .Cin(c51) , .Sum(s52) , .Cout(c52));
	FA fa34(.A(w35),.B(s44) , .Cin(c52) , .Sum(s53) , .Cout(c53));
	FA fa44(.A(w45),.B(s45) , .Cin(c53) , .Sum(s54) , .Cout(c54));
	FA fa54(.A(w55),.B(s46) , .Cin(c54) , .Sum(s55) , .Cout(c55));
	FA fa64(.A(w65),.B(s47) , .Cin(c55) , .Sum(s56) , .Cout(c56));
	FA fa74(.A(w75),.B(c47) , .Cin(c56) , .Sum(s57) , .Cout(c57));

	//6
	wire w06 , w16 , w26 , w36 , w46 , w56 , w66 , w76;
	And and05(.a(D1[0]) , .b(D2[6]) , .out(w06));
	And and15(.a(D1[1]) , .b(D2[6]) , .out(w16) );
	And and25(.a(D1[2]) , .b(D2[6]) , .out(w26) );
	And and35(.a(D1[3]) , .b(D2[6]) , .out(w36) );
	And and45(.a(D1[4]) , .b(D2[6]) , .out(w46) );
	And and55(.a(D1[5]) , .b(D2[6]) , .out(w56) );
	And and65(.a(D1[6]) , .b(D2[6]) , .out(w66) );
	And and75(.a(D1[7]) , .b(D2[6]) , .out(w76) );


	wire c60 , c61 , c62 , c63 , c64 , c65 , c66, c67 , s61 , s62 , s63 , s64 , s65 , s66 , s67 ;
	FA fa04(.A(w06),.B(s51) , .Cin(1'b0) , .Sum(out[6]) , .Cout(c60));
	FA fa14(.A(w16),.B(s52) , .Cin(c60) , .Sum(s61) , .Cout(c61));
	FA fa24(.A(w26),.B(s53) , .Cin(c61) , .Sum(s62) , .Cout(c62));
	FA fa34(.A(w36),.B(s54) , .Cin(c62) , .Sum(s63) , .Cout(c63));
	FA fa44(.A(w46),.B(s55) , .Cin(c63) , .Sum(s64) , .Cout(c64));
	FA fa54(.A(w56),.B(s56) , .Cin(c64) , .Sum(s65) , .Cout(c65));
	FA fa64(.A(w66),.B(s57) , .Cin(c65) , .Sum(s66) , .Cout(c66));
	FA fa74(.A(w76),.B(c57) , .Cin(c66) , .Sum(s67) , .Cout(c67));

	//7
	wire w07 , w17 , w27 , w37 , w47 , w57 , w67 , w77;
	And and05(.a(D1[0]) , .b(D2[7]) , .out(w07));
	And and15(.a(D1[1]) , .b(D2[7]) , .out(w17) );
	And and25(.a(D1[2]) , .b(D2[7]) , .out(w27) );
	And and35(.a(D1[3]) , .b(D2[7]) , .out(w37) );
	And and45(.a(D1[4]) , .b(D2[7]) , .out(w47) );
	And and55(.a(D1[5]) , .b(D2[7]) , .out(w57) );
	And and65(.a(D1[6]) , .b(D2[7]) , .out(w67) );
	And and75(.a(D1[7]) , .b(D2[7]) , .out(w77) );


	wire c70 , c71 , c72 , c73 , c74 , c75 , c76, c77 , s71 , s72 , s73 , s74 , s75 , s76 , s77 ;
	FA fa04(.A(w07),.B(s71) , .Cin(1'b0) , .Sum(out[7]) , .Cout(c70));
	FA fa14(.A(w17),.B(s72) , .Cin(c70) , .Sum(out[8]) , .Cout(c71));
	FA fa24(.A(w27),.B(s73) , .Cin(c71) , .Sum(out[9]) , .Cout(c72));
	FA fa34(.A(w37),.B(s74) , .Cin(c72) , .Sum(out[10]) , .Cout(c73));
	FA fa44(.A(w47),.B(s75) , .Cin(c73) , .Sum(out[11]) , .Cout(c74));
	FA fa54(.A(w57),.B(s76) , .Cin(c74) , .Sum(out[12]) , .Cout(c75));
	FA fa64(.A(w67),.B(s77) , .Cin(c75) , .Sum(out[13]) , .Cout(c76));
	FA fa74(.A(w77),.B(c77) , .Cin(c76) , .Sum(out[14]) , .Cout(c77));
	FA fa84(.A(c77),.B(1'b1) , .Cin(1'b0) , .Sum(out[14]) , .Cout());//check


endmodule
