      � H  FP        V3��         �         G   IEEE       IEEE �)     �      IEEE   STD_LOGIC_1164   ALL     �)     �      IEEE   STD_LOGIC_UNSIGNED   ALL     �)     �      work   STD_SAD   ALL     �)     :   Datapath_FirstSearch  A �)        /  '  .�  6�  N!  e�  }  �q  ��  �Q  ��  �  �a � A 0� 8� @Q H! O� W� _� ga o1 w ~� �� �q �A � �� �� �� �Q �! �� �a �1 � �� � q "� *� B! Y� q �q       2  *�  2�  :�  R	  iy  ��  �Y  ��  �9  ީ  �y  �I � ) 4� <i D9 L	 S� [� cy kI s z� �� �� �Y �) �� �� �� �i �9 �	 �� �I � �� �� � Y &� .� F	 ]y t� �Y  �  �  �          A     +  q  Y     �)     v  ��          *�     :   CLK  *�  Y     p   $  '      #)          Y     :   START  2�  Y     p   %  .�      #)          Y     :   foundBetterSAD  :�  Y     p   &  6�      #)          Y     @     Bi     ' Q3     >�  FQ      J9     @      Bi     v  �Z     Bi      R	     :   cyclesPerPU  R	  Y     p   '  N!      J9          Y     @     Y�     ' Q3     U�  ]�      a�     @      Y�     v  �Z     Y�      iy     :   
borderLeft  iy  Y     p   (  e�      a�          Y     @     qI     ' Q3     ma  u1      y     @      qI     v  �Z     qI      ��     :   borderRight  ��  Y     p   )  }      y          Y     @     ��     ' Q3     ��  ��      ��     @      ��     v  �Z     ��      �Y     :   borderUp  �Y  Y     p   *  �q      ��          Y     @     �)     ' Q3     �A  �      ��     @      �)     v  �Z     �)      ��     :   
borderDown  ��  Y     p   +  ��      ��          Y     @     ��     ' Q3     ��  ��      �i     @      ��     v  �Z     ��      �9     :   initCenterX  �9  Y     p   ,  �Q      �i          Y     @     �	     ' Q3     �!  ��      ��     @      �	     v  �Z     �	      ީ     :   initCenterY  ީ  Y     p   -  ��      ��          Y     :   
incDoAgain  �y  Y     p   .  �      #)          Y     :   donePU  �I  Y     p   /  �a      #)          Y     @     �     ' Q3     �1  �      ��     @      �     v  �Z     �     �     :   	sel_distX �  Y     p   0 �      ��          Y     @    �     ' Q3    	� q     Y     @     �     v  �Z    �     )     :   	sel_distY )  Y     p   1 A     Y          Y     @    $�     ' Q3    ! (�     ,�     @     $�     v  �Z    $�     4�     :   sel_candidates 4�  Y     p   2 0�     ,�          Y     :   isRefinement <i  Y     p   3 8�      #)          Y     :   loadregNumPUsLevel D9  Y     p   4 @Q      #)          Y     :   op_typeX L	  Y     p   5 H!      #)          Y     :   op_typeY S�  Y     p   6 O�      #)          Y     :   incRegCurVecX [�  Y     p   7 W�      #)          Y     :   incRegCurVecY cy  Y     p   8 _�      #)          Y     :   rstRegCurVecX kI  Y     p   9 ga      #)          Y     :   rstRegCurVecY s  Y     p   : o1      #)          Y     :   incRegNumLevels z�  Y     p   ; w      #)          Y     :   rstRegNumLevels ��  Y     p   < ~�      #)          Y     :   initData ��  Y     p   = ��      #)          Y     :   initIncrement �Y  Y     p   > �q      #)          Y     :   rstRegPUsFinished �)  Y     p   ? �A      #)          Y     :   	sendToMem ��  Y     p   @ �      #)          Y     :   
loadCurVec ��  Y     p   A ��      #)          Y     :   loadByPassOutOfAnyBound ��  Y     p   B ��      #)          Y     :   incRegPUsFinished �i  Y     p   C ��      #)          Y     :   loadVecFound �9  Y     p   D �Q      #)          Y     :   loadByPassVecFound �	  Y     p   E �!      #)          Y     :   
writeCache ��  Y     p   F ��      #)          Y     @    ة     ' Q3    �� ܑ     �y     @     ة     v  �Z    ة     �I     :   searchRange �I  Y     p   G �a     �y          Y     :   vecFound �  Y     p   H �1     #)          Y     :   byPassVecFound ��  Y     p   I �     #)          Y     :   isOutOfAnyBound ��  Y     p   J ��     #)          Y     :   byPassIsOutOfAnyBound �  Y     p   K �     #)          Y     :   hasPassedNumLevels Y  Y     p   L q     #)          Y     @    )     ' Q3    A      �     @     )     v  �Z    )     &�     :   doAgain &�  Y     p   M "�    �          Y     :   finishSendPartitions .�  Y     p   N *�     #)          Y     @    6i     ' Q3    2� :Q     >9     @     6i     v  �Z    6i     F	     :   vecMemX F	  Y     p   O B!    >9          Y     @    M�     ' Q3    I� Q�     U�     @     M�     v  �Z    M�     ]y     :   vecMemY ]y  Y     p   P Y�    U�          Y     @    eI     ' Q3    aa i1     m     @     eI     v  �Z    eI     t�     :   bestVecX t�  Y     p   Q q    m          Y     @    |�     ' Q3    x� ��     ��     @     |�     v  �Z    |�     �Y     :   bestVecY �Y  Y     p   R �q    ��          Y     P             %     �  q         �  �  �  A �     �   TC:/Users/Brunno/Desktop/TZSearch_Github/TZSearch/TZSearch_F/Datapath_FirstSearch.vhd �)  �                datapath_firstsearch       work      datapath_firstsearch       work      std_logic_1164       IEEE      standard       std