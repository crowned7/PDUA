BEGIN:		MOV		ACC, CTE
					Q	
					MOV		DPTR, ACC 	    	# move address of Q to DPTR
					MOV 	ACC, [DPTR]	    	# Load Q in ACC.	
LessSignfBit_Q:         LSL7	ACC
					MSB		ACC				        # MostSignfBit. Si 10000000, MSB = 00000001.
					MOV		A, ACC
LessSignfBit_Q_inACC:		INV 	ACC
					MOV		A, ACC 
					MOV 	ACC, CTE
					0x01				    	      # CTE + 1
					ADD		ACC, A			      
					MOV		A, ACC            # A = -(LSB (Q))
Load_Q-1: 			MOV 	ACC,CTE
					Q-1						         
					MOV		DPTR, ACC 		   
					MOV 	ACC, [DPTR]		  
					ADD 	ACC, A			      # ACC = -(LSB (Q)) + (Q-1)
SAME:		JZ						            # Si -(LSB (Q)) + (Q-1) = 0. LSB(Q) == 1 && Q-1 = 1 || LSB(Q) == 0 && Q-1 = 0
					L_S_R					          # Sino, LSB (Q) = Q-1, JUMP TO L_S_R (Desplazamieto hacia la izquierda). Si son iguales, se desplaza a la derecha nada mas
DIFF: 	MOV 	ACC, CTE
					0xFF					          # - 1
					MOV		A, ACC 	
Load_Q:				MOV		ACC, CTE
					Q						
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		    # ACC = Q
Find_LSB_Q:         LSL7	ACC     # Desplazamiento hacia izaquierda 7 veces. El bit menos significativo ahora es el más significativo.
					MSB		ACC
Check_LSB_Q:		ADD 	ACC, A			# LSB(Q) + (-1)
					JZ						
					SUBSTRACTING					
ADDING:				MOV 	ACC, CTE
					A_var					
					MOV		DPTR, ACC 	
          MOV 	ACC, [DPTR]
					MOV		A, ACC			# A = A_var
					MOV 	ACC, CTE		
					M 						
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = M
					ADD     ACC, A			# ACC = a_VAR + M
					MOV		A, ACC 			
JMP_next:		JMP 	CTE
					new_A_var				
SUBSTRACTING:	 MOV		ACC, CTE		
					M						
					MOV		DPTR, ACC 	
					MOV 	ACC, [DPTR]		# ACC = M	
Neg_M:		INV 	ACC		        # ACC = - M		
					MOV		A, ACC 			  # A = - M
					MOV 	ACC, CTE
					0x01					
					ADD		ACC, A			  # ACC = - M
					MOV		A, ACC 			  # A = - M
					MOV     ACC, CTE		
					A_var					
					MOV		DPTR, ACC 	
					MOV 	ACC, [DPTR]		# ACC = A_var
					ADD	    ACC, A			# ACC = A_var + (-M)
					MOV     A, ACC			# A = A_var + (-M)
new_A_var:	MOV 	ACC, CTE		
					A_var 							
					MOV		DPTR, ACC	
					MOV 	ACC, A			
					MOV		[DPTR], ACC						
LessSignif:	MOV		ACC, CTE	
					Q						
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = Q
Find_LSB_Q:         LSL7	ACC # Desplazamiento a izquierda 7 veces
					MSB		ACC				
					MOV		A, ACC 			  # A = LSB(Q)
new_Q-1: 	MOV 	ACC, CTE		
					Q-1						
					MOV     DPTR, ACC		
					MOV 	ACC, A			  # ACC = LSB(Q)
					MOV		[DPTR], ACC	  # Q - 1 = LSB(Q)
LSR_Q:				MOV		ACC, CTE		
					Q						
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = Q
					LSR 	ACC				    # Desplazamiento hacia izquierda
					MOV		A, ACC 			  # A = LSR(Q)
new_Q: 			MOV 	ACC, CTE		
					Q						
					MOV     DPTR, ACC		
					MOV 	ACC, A			  # ACC = LSR(Q)
					MOV		[DPTR], ACC									
Load_-1:	MOV 	ACC, CTE	
					0xFF					      # ACC =  - 1
					MOV		A, ACC 			  # A = - 1
Load_LSB_A:			MOV 	ACC, CTE 		
					A_var					
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = A_var
					LSL7	ACC
					MSB		ACC		
					ADD		ACC, A			# ACC = LSB(A)+(-1)
					JZ     	            	# Si (LSB (A) = 0), entonces LSB(A) = 1
					1_OR_Q					# LSB(A) = 1, Se salta a 1_OR_Q. Máscara. Q OR 10000000, MSB(Q) = 1		
0_AND_Q:			MOV		ACC, CTE		# Si no se salta o  si se salta...
					Q						
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		
					MOV		A, ACC			# A = Q
					MOV		ACC, CTE	
					Mask_AND				
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = MSK_AND
					AND     ACC, A			
					MOV     A, ACC			# A = MSK_AND
					JMP		CTE				
					Updt_Q_AND_OR
1_OR_Q:				MOV		ACC, CTE		
					Q						
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = Q
					MOV		A, ACC			# A = Q
					MOV		ACC, CTE		# ACC = Q
					Mask_OR				
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = MSK_OR	
					OR	    ACC, A			
					MOV     A, ACC			# A = MSK_OR
new_Q_AND_OR: 		MOV 	ACC, CTE		
					Q 									
					MOV		DPTR, ACC		
					MOV 	ACC, A			# ACC = MSK_OR
					MOV		[DPTR], ACC	# Q = MSK_OR	
Load_-1:			MOV 	ACC, CTE		
					0xFF					
					MOV		A, ACC 			# A = - 1
Load_MSB_A:			MOV 	ACC, CTE 		
					A_var				
					MOV		DPTR, ACC 	
					MOV 	ACC, [DPTR]	  	# ACC = A_var
					MSB 	ACC			      	# MSB(A_var)
					ADD		ACC, A		    	# MSB(A)+(-1)
CMPR_MSB:	JN						        # Si MSB (A) es negativo, entonces MSB(A) = 0
					0_AND_A				      	# JUMP hacia 0_AND_A
					JZ     	            	# Si (MSB (A) = 0), entonces MSB(A) = 1
					1_OR_A				      	# JUMP hacia 1_OR_A	
0_AND_A:	MOV		ACC, CTE	
					A_var					
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		  # ACC = A_var
					LSR 	ACC			      	# Desplazamiento hacia derecha
					MOV		A, ACC	  	  	# Load A_var in A register
					MOV		ACC, CTE		
					Mask_AND				
					MOV		DPTR, ACC 	
					MOV 	ACC, [DPTR] 		# ACC = MSK_AND
					AND     ACC, A	
					MOV     A, ACC		  	# A = MSK_AND
					JMP		CTE
					Updt_A_AND_OR
1_OR_A:				MOV		ACC, CTE
					A_var				
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		  # ACC = A_var
					LSR 	ACC				      # Desplazamiento a derecha
					MOV		A, ACC			    # A = A_var
					MOV		ACC, CTE		 
					Mask_OR					
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		  # ACC = MSK_OR	
					OR	  ACC, A			
					MOV   A, ACC		  	  # ACC = A
new_A_AND_OR:	MOV 	ACC, CTE		
					A_var 				
					MOV		DPTR, ACC	
					MOV 	ACC, A		    	# ACC = A
					MOV		[DPTR], ACC		
Test_loop:			MOV 	ACC, CTE		
					0xFF			
					MOV		A, ACC 			    # A = - 1
					MOV		ACC, CTE      
					i			
					MOV		DPTR, ACC 		
					MOV 	ACC, [DPTR]		# ACC = i			
					ADD     ACC, A			# ACC = i - 1
					MOV		A, ACC 		
new_i: 		MOV 	ACC, CTE	
					count 								
					MOV		DPTR, ACC	
					MOV 	ACC, A		  	# ACC = A
					MOV		[DPTR], ACC		
					MOV 	ACC, A	  	  # Bandera
					JZ					      	# ¿ACC = i == 0?
GoTo_END_LOOP:		END_loop
					JMP 	CTE			    	# Se repite el ciclo si i != 0
					INIT_loop
END_loop:			MOV 	ACC, CTE	
					A_var 										
					MOV		DPTR, ACC		
					MOV 	ACC, [DPTR]		# ACC = A_var
					MOV 	A, ACC			  # a = A_var
					MOV 	ACC, CTE	  	
					Q 									
					MOV		DPTR, ACC		
					MOV 	ACC, [DPTR]		# ACC = Q
FINISH:		HALT
Q:			0x03					      	# Q =  Multilicador
M:			0x02						     	# M = Multiplicando
Q-1:		0x00						    	# Q-1 = 0 (El bit menos significativo de Q - 1)
A_var:		0x00					  		# A_var = 00000000
i:		0x08						      	# Límite del ciclo, 8 veces para 8 bits
Mask_AND:   0x7F							# 01111111 = (127)
Mask_OR:   	0x80							# 10000000 = (128)
