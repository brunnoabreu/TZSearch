----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:47:17 08/04/2015 
-- Design Name: 
-- Module Name:    UC_MainFirst - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC_MainFirst is
	Port(
			CLK							: in STD_LOGIC;
			START							: in STD_LOGIC;
			finishSendPartitions		: in STD_LOGIC;
			doAgain						: in STD_LOGIC_VECTOR(2 downto 0);
			is8x8or16x4					: in STD_LOGIC;
			isOutOfAnyBound			: in STD_LOGIC;
			byPassIsOutOfAnyBound	: in STD_LOGIC;
			hasPassedNumLevels		: in STD_LOGIC;
			vecFound						: in STD_LOGIC;
			byPassVecFound				: in STD_LOGIC;
			loadVecFound				: out STD_LOGIC;
			loadByPassVecFound		: out STD_LOGIC;
			writeCache					: out STD_LOGIC;
			loadCurVec					: out STD_LOGIC;
			loadByPassOutOfAnyBound : out STD_LOGIC;
			sendToMem					: out STD_LOGIC;
			rstRegPUsFinished			: out STD_LOGIC;
			incDoAgain					: out STD_LOGIC;
			sel_distX					: out STD_LOGIC_VECTOR(2 downto 0);
			sel_distY					: out STD_LOGIC_VECTOR(2 downto 0);
			sel_candidates				: out STD_LOGIC_VECTOR(1 downto 0);
			loadregNumPUsLevel		: out STD_LOGIC;
			incRegPUsFinished			: out STD_LOGIC;
			op_typeX						: out STD_LOGIC;
			op_typeY						: out STD_LOGIC;
			incRegCurVecX				: out STD_LOGIC;
			incRegCurVecY				: out STD_LOGIC;
			rstRegCurVecX				: out STD_LOGIC;
			rstRegCurVecY				: out STD_LOGIC;
			incRegNumLevels			: out STD_LOGIC;
			rstRegNumLevels			: out STD_LOGIC;
			initData						: out STD_LOGIC;
			initIncrement				: out STD_LOGIC;
			START2						: out STD_LOGIC;
			waitCycles					: out STD_LOGIC;
			validBit						: out STD_LOGIC;
			done							: out STD_LOGIC
	);	
end UC_MainFirst;

architecture Behavioral of UC_MainFirst is

type t_state is (idle, wait1, initialFourCandidates, initialFourCandidates_2, initialFourCandidates_3, fourCandidates_2, fourCandidates_2_5, fourCandidates_3, fourCandidates_3_5, fourCandidates_4,
 fourCandidates_4_5, fourCandidates_5, waitAndDecide1, waitAndDecide2, waitAndDecide3, waitAndDecide4,
 waitAndDecide5, waitAndDecide6, waitAndDecide7, waitAndDecide8, waitAndDecide9, waitAndDecide10, waitAndDecide11, waitAndDecide12, initialEightCandidates, initialEightCandidates_2, initialEightCandidates_3, eightCandidates_2, eightCandidates_2_5, eightCandidates_3,
 eightCandidates_3_5, eightCandidates_4, eightCandidates_4_5, eightCandidates_5, eightCandidates_5_5, eightCandidates_6, eightCandidates_6_5,
 eightCandidates_7, eightCandidates_7_5, eightCandidates_8, eightCandidates_8_5, eightCandidates_9, initialSixteenCandidates_2, initialSixteenCandidates_3, sixteenCandidates_1, sixteenCandidates_1_5, sixteenCandidates_2, sixteenCandidates_2_5, 
 sixteenCandidates_3, sixteenCandidates_3_5, sixteenCandidates_4, sixteenCandidates_4_5, sixteenCandidates_5, sixteenCandidates_5_5, sixteenCandidates_6, 
 sixteenCandidates_6_5, sixteenCandidates_7, sixteenCandidates_7_5, sixteenCandidates_8, sixteenCandidates_8_5, sixteenCandidates_9, sixteenCandidates_9_5, 
 sixteenCandidates_10, sixteenCandidates_10_5, sixteenCandidates_11, sixteenCandidates_11_5, sixteenCandidates_12, sixteenCandidates_12_5, sixteenCandidates_13, 
 sixteenCandidates_13_5, sixteenCandidates_14, sixteenCandidates_14_5, sixteenCandidates_15, sixteenCandidates_15_5, sixteenCandidates_16, sixteenCandidates_16_5, sixteenCandidates_17, stateDone);
signal state, nextState: t_state;

signal isNotOutOfAnyBound, isValid, isNotVecFound: STD_LOGIC;
signal concatVecOutBound: STD_LOGIC_VECTOR(1 downto 0);

begin

concatVecOutBound <= vecFound & isOutOfAnyBound;
isNotOutOfAnyBound <= not (isOutOfAnyBound);
isNotVecFound		 <= not (vecFound);
isValid <= isNotOutOfAnyBound and isNotvecFound;

	process(CLK, START)
	begin
		if(START = '0') then
			state <= idle;
		elsif(CLK'event and CLK = '1') then
			state <= nextState;
		end if;
	end process;

	process(state, concatVecOutBound, vecFound, byPassVecFound, finishSendPartitions, doAgain, is8x8or16x4, hasPassedNumLevels, isOutOfAnyBound, isValid, isNotVecFound, isNotOutOfAnyBound, byPassIsOutOfAnyBound)
	begin
		case state is
			when idle =>
				loadByPassOutOfAnyBound <= '0';
				incDoAgain <= '0';
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				incRegPUsFinished <= '0';
				loadregNumPUsLevel <= '0';
				sel_candidates <= "00";
				waitCycles <= '0';
				rstRegPUsFinished <= '0';
				done <= '0';
				START2 <= '0';
				sel_distX <= "000";
				sel_distY <= "000";
				op_typeX <= '1';
				op_typeY <= '1';
				incRegCurVecX <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecY <= '0';
				initData <= '0';
				initIncrement <= '0';
				incRegNumLevels <= '0';
				rstRegNumLevels <= '0';
				validBit <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				writeCache <= '0';
				nextState <= wait1;
			
			when wait1 =>
				initData <= '1';
				nextState <= initialFourCandidates;
			
			when initialFourCandidates =>
				incDoAgain <= '0';
				loadVecFound <= '1';
				incRegCurVecX <= '1';
				initData <= '0';
				nextState <= initialFourCandidates_2;			

			when initialFourCandidates_2 =>
				incRegNumLevels <= '0';
				loadregNumPUsLevel <= '1';
				sel_candidates <= "00";
				incDoAgain <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				incRegCurVecY <= '1';
				rstRegCurVecX <= '1';
				loadCurVec <= '1';
				nextState <= initialFourCandidates_3;
			
			when initialFourCandidates_3 =>
				incRegPUsFinished <= '0';
				loadregNumPUsLevel <= '0';
				sel_candidates <= "00";
				validBit <= isValid;
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '1';
				op_typeX <= '0';
				rstRegCurVecY <= '1';
				loadByPassVecFound <= '1';
				nextState <= fourCandidates_2;
				loadByPassOutOfAnyBound <= '1';
				if(isOutOfAnyBound = '0') then
					if(vecFound = '1') then
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
					else
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					end if;
				else
					incRegPUsFinished <= '1';
					initIncrement <= '0';
					sendToMem <= '0';
				end if;

--NECESSITA-SE DE UM NOVO SINAL: LOADVECFOUND, NA CACHE.

			when fourCandidates_2 =>
				writeCache <= '0';
				incRegPUsFinished <= '0';
				waitCycles <= '0';
				START2 <= '1';
				incDoAgain <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				sendToMem <= '0';
				loadCurVec <= '0';
				loadByPassVecFound <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadVecFound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					incRegCurVecY <= '1';
					rstRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= fourCandidates_2_5;
					writeCache <= '0';
					if(is8x8or16x4 = '1') then
						nextState <= fourCandidates_3;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= fourCandidates_3;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= fourCandidates_3;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= fourCandidates_3;
					end if;
				end if;

			when fourCandidates_2_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				nextState <= fourCandidates_3;
			
			when fourCandidates_3 =>
				loadVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				loadByPassVecFound <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					nextState <= fourCandidates_3_5;
					loadByPassOutOfAnyBound <= '1';
					if(is8x8or16x4 = '1') then
						nextState <= fourCandidates_4;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= fourCandidates_4;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= fourCandidates_4;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= fourCandidates_4;
					end if;
				end if;
				
			when fourCandidates_3_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				nextState <= fourCandidates_4;
			
			when fourCandidates_4 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				sendToMem <= '0';
				loadCurVec <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					loadByPassOutOfAnyBound <= '1';
					nextState <= fourCandidates_4_5;
					if(is8x8or16x4 = '1') then
						nextState <= fourCandidates_5;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= fourCandidates_5;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= fourCandidates_5;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= fourCandidates_5;
					end if;
				end if;

			when fourCandidates_4_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				nextState <= fourCandidates_5;
	
			when fourCandidates_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				sendToMem <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					nextState <= waitAndDecide1;
				end if;
	
			when initialEightCandidates =>
				incDoAgain <= '0';
				incRegCurVecX <= '1';
				rstRegCurVecY <= '1';
				initData <= '0';
				nextState <= initialEightCandidates_2;
				
			when initialEightCandidates_2 =>
				loadVecFound <= '1';
				incRegNumLevels <= '0';
				loadregNumPUsLevel <= '1';
				sel_candidates <= "01";
				incDoAgain <= '0';
				op_typeX <= '0';
				op_typeY <= '1';
				incRegCurVecX <= '1';
				incRegCurVecY <= '1';
				rstRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				if(doAgain = "010") then
					sel_distX <= "001";
					sel_distY <= "001";
				else
					sel_distX <= "010";
					sel_distY <= "010";
				end if;
				loadCurVec <= '1';
				nextState <= initialEightCandidates_3;
				
			when initialEightCandidates_3 =>
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadregNumPUsLevel <= '0';
				validBit <= isValid;
				incRegCurVecY <= '1';
				rstRegCurVecX <= '1';
				incRegCurVecX <= '0';
				op_typeX <= '0';
				rstRegCurVecY <= '0';
				START2 <= '1';
				loadByPassVecFound <= '1';
				loadByPassOutOfAnyBound <= '1';
				nextState <= eightCandidates_2;
				if(isOutOfAnyBound = '0') then
					writeCache <= '1';
					if(vecFound = '1') then
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
					else
						initIncrement <= '1';
						sendToMem <= '1';
					end if;
				else
					incRegPUsFinished <= '1';
					initIncrement <= '0';
					sendToMem <= '0';
				end if;
			
			when eightCandidates_2 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				incDoAgain <= '0';
				waitCycles <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				loadByPassOutOfAnyBound <= '0';
				op_typeX <= '1';
				op_typeY <= '0';
				nextState <= eightCandidates_2;
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					incRegCurVecX <= '1';
					incRegCurVecY <= '1';
					op_typeX <= '0';
					op_typeY <= '0';
					loadByPassOutOfAnyBound <= '1';
					nextState <= eightCandidates_2_5;
					if(is8x8or16x4 = '1') then
						nextState <= eightCandidates_3;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_3;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= eightCandidates_3;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_3;
					end if;
				end if;
				
			when eightCandidates_2_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= eightCandidates_3;
			
			when eightCandidates_3 =>
				loadByPassVecFound <= '0';
				loadVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecX <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					rstRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= eightCandidates_3_5;
					if(is8x8or16x4 = '1') then
						nextState <= eightCandidates_4;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_4;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= eightCandidates_4;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_4;
					end if;
				end if;

			
			when eightCandidates_3_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= eightCandidates_4;
	
			when eightCandidates_4 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				op_typeX <= '1';
				op_typeY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= eightCandidates_4;
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					incRegCurVecX <= '1';
					incRegCurVecY <= '1';
					op_typeX <= '1';
					op_typeY <= '0';
					loadByPassOutOfAnyBound <= '1';
					nextState <= eightCandidates_4_5;
					if(is8x8or16x4 = '1') then
						nextState <= eightCandidates_5;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_5;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= eightCandidates_5;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_5;
					end if;
				end if;

				
			when eightCandidates_4_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= eightCandidates_5;
		
			when eightCandidates_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					rstRegCurVecX <= '1';
					incRegCurVecY <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= eightCandidates_5_5;
					if(is8x8or16x4 = '1') then
						nextState <= eightCandidates_6;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_6;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= eightCandidates_6;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_6;
					end if;
				end if;

			
			when eightCandidates_5_5 =>
				loadByPassVecFound <= '0';
				loadVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= eightCandidates_6;
		
			when eightCandidates_6 =>
				loadByPassVecFound <= '0';
				loadVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					incRegCurVecX <= '1';
					incRegCurVecY <= '1';
					op_typeY <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= eightCandidates_6_5;
					if(is8x8or16x4 = '1') then
						nextState <= eightCandidates_7;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_7;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= eightCandidates_7;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_7;
					end if;
				end if;

			
			when eightCandidates_6_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= eightCandidates_7;
			
			when eightCandidates_7 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					loadByPassOutOfAnyBound <= '1';
					nextState <= eightCandidates_7_5;
					if(is8x8or16x4 = '1') then
						nextState <= eightCandidates_8;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_8;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= eightCandidates_8;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_8;
					end if;
				end if;

			
--			when eightCandidates_7_5 =>
--				loadByPassOutOfAnyBound <= '0';
--				loadCurVec <= '0';
--				sendToMem <= '0';
--				incRegCurVecY <= '0';
--				rstRegCurVecX <= '0';
--				incRegCurVecX <= '0';
--				rstRegCurVecY <= '0';
--				nextState <= eightCandidates_8;
			
--			when eightCandidates_8 =>
--				loadCurVec <= '0';
--				sendToMem <= '0';
--				incRegCurVecY <= '0';
--				rstRegCurVecX <= '0';
--				incRegCurVecX <= '0';
--				rstRegCurVecY <= '0';
--				loadByPassOutOfAnyBound <= '0';
--				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1') then
--					loadCurVec <= '1';
--					validBit <= isOutOfAnyBound;
--					loadByPassOutOfAnyBound <= '1';
--					nextState <= eightCandidates_8_5;
--					if(is8x8or16x4 = '1') then
--						nextState <= eightCandidates_9;
--					end if;
--					if(isOutOfAnyBound = '0') then
--						initIncrement <= '1';
--						sendToMem <= '1';
--					else
--						initIncrement <= '0';
--						nextState <= eightCandidates_9;
--					end if;
--					if(doAgain = "010") then
--						sel_distX <= "001";
--						sel_distY <= "001";
--					else
--						sel_distX <= "010";
--						sel_distY <= "010";
--					end if;
--				end if;

			
			when eightCandidates_7_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= eightCandidates_8;
			
			when eightCandidates_8 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					loadByPassOutOfAnyBound <= '1';
					nextState <= eightCandidates_8_5;
					if(is8x8or16x4 = '1') then
						nextState <= eightCandidates_9;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_9;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= eightCandidates_9;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= eightCandidates_9;
					end if;
				end if;
			
			when eightCandidates_8_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= eightCandidates_9;
				
			when eightCandidates_9 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					nextState <= waitAndDecide1;
				end if;
			
--			when initialSixteenCandidates =>
--				incDoAgain <= '0';
--				incRegCurVecX <= '1';
--				rstRegCurVecY <= '1';
--				initData <= '0';
--				nextState <= initialSixteenCandidates_2;
				
			when initialSixteenCandidates_2 =>
				incRegNumLevels <= '0';
				loadregNumPUsLevel <= '1';
				sel_candidates <= "10";
				incDoAgain <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				incRegCurVecY <= '1';
				incRegCurVecX <= '1';
				op_typeX <= '0';
				op_typeY <= '1';
				if(doAgain = "100") then
					sel_distX <= "010";
					sel_distY <= "010";
				else
					sel_distX <= "011";
					sel_distY <= "011";
				end if;
				loadCurVec <= '1';
				nextState <= initialSixteenCandidates_3;
				
			when initialSixteenCandidates_3 =>
				incRegPUsFinished <= '0';
				loadregNumPUsLevel <= '0';
				validBit <= isValid;
				incRegCurVecY <= '1';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '1';
				op_typeX <= '0';
				rstRegCurVecY <= '0';
				START2 <= '1';
				loadByPassVecFound <= '1';
				loadByPassOutOfAnyBound <= '1';
				nextState <= sixteenCandidates_2;
				if(isOutOfAnyBound = '0') then
					writeCache <= '1';
					if(vecFound = '1') then
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
					else
						initIncrement <= '1';
						sendToMem <= '1';
					end if;
				else
					incRegPUsFinished <= '1';
					initIncrement <= '0';
					sendToMem <= '0';
				end if;
			
			when sixteenCandidates_1 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incDoAgain <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '0';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '1';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					rstRegCurVecX <= '0';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_1_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_2;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_2;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_2;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_2;
					end if;
					if(doAgain = "100") then
						sel_distX <= "010";
						sel_distY <= "001";
					else
						sel_distX <= "011";
						sel_distY <= "011";
					end if;
				end if;

			
			when sixteenCandidates_1_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_2;
			
			when sixteenCandidates_2 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				waitCycles <= '0';
				incDoAgain <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '1';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					rstRegCurVecX <= '0';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_2_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_3;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_3;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_3;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_3;
					end if;
				end if;
			
			when sixteenCandidates_2_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_3;
			
			when sixteenCandidates_3 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '1';
					incRegCurVecY <= '1';
					rstRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_3_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_4;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_4;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_4;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_4;
					end if;
				end if;
			
			when sixteenCandidates_3_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_4;
			
			when sixteenCandidates_4 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_4_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_5;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_5;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_5;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_5;
					end if;
				end if;
			
			when sixteenCandidates_4_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_5;
				
			when sixteenCandidates_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_5_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_6;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_6;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_6;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_6;
					end if;
				end if;
			
			when sixteenCandidates_5_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_6;
			
			when sixteenCandidates_6 =>
				loadByPassVecFound <= '0';
				loadVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_6_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_7;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_7;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_7;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_7;
					end if;
				end if;
			
			when sixteenCandidates_6_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_7;
				
			when sixteenCandidates_7 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_7_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_8;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_8;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_8;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_8;
					end if;
				end if;
			
			when sixteenCandidates_7_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_8;
			
			when sixteenCandidates_8 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeX <= '1';
					op_typeY <= '0';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_8_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_9;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_9;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_9;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_9;
					end if;
				end if;
			
			when sixteenCandidates_8_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_9;
			
			when sixteenCandidates_9 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_9_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_10;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_10;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_10;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_10;
					end if;
				end if;
			
			when sixteenCandidates_9_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadByPassOutOfAnyBound <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= sixteenCandidates_10;
			
			when sixteenCandidates_10 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_10_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_11;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_11;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_11;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_11;
					end if;
				end if;
			
			when sixteenCandidates_10_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= sixteenCandidates_11;
			
			when sixteenCandidates_11 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '0';
					op_typeX <= '1';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_11_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_12;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_12;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_12;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_12;
					end if;
				end if;
			
			when sixteenCandidates_11_5 =>
				loadByPassVecFound <= '0';
				loadVecFound <= '0';
				writeCache <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= sixteenCandidates_12;

			when sixteenCandidates_12 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeX <= '0';
					op_typeY <= '1';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_12_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_13;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_13;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_13;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_13;
					end if;
				end if;
			
			when sixteenCandidates_12_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= sixteenCandidates_13;
			
			when sixteenCandidates_13 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '1';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_13_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_14;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_14;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_14;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_14;
					end if;
				end if;
			
			when sixteenCandidates_13_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= sixteenCandidates_14;
			
			when sixteenCandidates_14 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '1';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_14_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_15;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_15;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_15;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_15;
					end if;
				end if;
			
			when sixteenCandidates_14_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= sixteenCandidates_15;
			
			when sixteenCandidates_15 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					op_typeY <= '1';
					incRegCurVecY <= '1';
					incRegCurVecX <= '1';
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_15_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_16;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_16;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_16;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_16;
					end if;
				end if;
			
			when sixteenCandidates_15_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= sixteenCandidates_16;
			
			when sixteenCandidates_16 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					loadByPassVecFound <= '1';
					loadVecFound <= '1';
					loadCurVec <= '1';
					validBit <= isValid;
					loadByPassOutOfAnyBound <= '1';
					nextState <= sixteenCandidates_16_5;
					if(is8x8or16x4 = '1') then
						nextState <= sixteenCandidates_17;
					end if;
					if(concatVecOutBound = "00") then
						writeCache <= '1';
						initIncrement <= '1';
						sendToMem <= '1';
					elsif(concatVecOutBound = "01") then
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_17;
					elsif(concatVecOutBound = "10") then
						writeCache <= '0';
						initIncrement <= '0';
						sendToMem <= '0';
						incRegPUsFinished <= '1';
						nextState <= sixteenCandidates_17;
					else
						writeCache <= '0';
						incRegPUsFinished <= '1';
						initIncrement <= '0';
						sendToMem <= '0';
						nextState <= sixteenCandidates_17;
					end if;
				end if;
				
			when sixteenCandidates_16_5 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				nextState <= sixteenCandidates_17;
				
			when sixteenCandidates_17 =>
				loadVecFound <= '0';
				loadByPassVecFound <= '0';
				writeCache <= '0';
				incRegPUsFinished <= '0';
				loadCurVec <= '0';
				sendToMem <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				incRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				loadByPassOutOfAnyBound <= '0';
				if(finishSendPartitions = '1' or byPassIsOutOfAnyBound = '1' or byPassVecFound = '1') then
					incRegCurVecX <= '0';
					incRegCurVecY <= '0';
					rstRegCurVecX <= '1';
					rstRegCurVecY <= '1';
					nextState <= waitAndDecide1;
				end if;
				
				
				

			when waitAndDecide1 =>
				incRegCurVecX <= '0';
				incRegCurVecY <= '0';
				rstRegCurVecX <= '0';
				rstRegCurVecY <= '0';
				nextState <= waitAndDecide2;
			
			when waitAndDecide2 =>
				nextState <= waitAndDecide3;

			when waitAndDecide3 =>
				nextState <= waitAndDecide4;

			when waitAndDecide4 =>
				nextState <= waitAndDecide5;

			when waitAndDecide5 =>
				nextState <= waitAndDecide6;
				
			when waitAndDecide6 =>
				nextState <= waitAndDecide7;
			
			when waitAndDecide7 =>
				nextState <= waitAndDecide8;
			
			when waitAndDecide8 =>
				nextState <= waitAndDecide9;
				
			when waitAndDecide9 =>
				waitCycles <= '1';
				nextState <= waitAndDecide10;
			
			when waitAndDecide10 =>
				rstRegPUsFinished <= '1';
				incRegNumLevels <= '1';
				nextState <= waitAndDecide12;

			when waitAndDecide11 =>
				incRegNumLevels <= '0';
--				rstRegPUsFinished <= '0';
--				nextState <= waitAndDecide12;

			when waitAndDecide12 =>
				incRegNumLevels <= '0';
				rstRegPUsFinished <= '0';
				incDoAgain <= '1';
				incRegCurVecX <= '1';
				rstRegCurVecY <= '1';
				op_typeX <= '1';
				op_typeY <= '1';
				sendToMem <= '0';
				initIncrement <= '0';
				loadVecFound <= '1';
				if(hasPassedNumLevels = '1') then
					nextState <= stateDone;
				else
					if(doAgain = "000") then
						sel_distX <= "001";
						sel_distY <= "001";
						nextState <= initialFourCandidates_2;
					elsif(doAgain = "001") then
						sel_distX <= "010";
						sel_distY <= "010";
						nextState <= initialEightCandidates_2;
					elsif(doAgain = "010") then
						sel_distX <= "011";
						sel_distY <= "011";
						nextState <= initialEightCandidates_2;
					elsif(doAgain = "011") then
						sel_distX <= "101";
						sel_distY <= "101";
						nextState <= initialSixteenCandidates_2;
					elsif(doAgain = "100") then
						sel_distX <= "111";
						sel_distY <= "111";
						nextState <= initialSixteenCandidates_2;
					else
						nextState <= stateDone;
					end if;
				end if;
				
			when stateDone =>
				incDoAgain <= '0';
				incRegNumLevels <= '0';
				done <= '1';
				
		end case;
	end process;

end Behavioral;

