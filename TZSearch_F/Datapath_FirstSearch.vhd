----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:22:18 07/13/2015 
-- Design Name: 
-- Module Name:    Datapath_FirstSearch - Behavioral 
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
use work.STD_SAD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Datapath_FirstSearch is
	Port(
		CLK							: in STD_LOGIC;
		START							: in STD_LOGIC;
		foundBetterSAD				: in STD_LOGIC;
		heightPU						: in STD_LOGIC_VECTOR(6 downto 0);
		widthPU						: in STD_LOGIC_VECTOR(6 downto 0);
		initCenterX					: in STD_LOGIC_VECTOR(7 downto 0);
		initCenterY					: in STD_LOGIC_VECTOR(7 downto 0);
		incDoAgain					: in STD_LOGIC;
		sel_distX					: in STD_LOGIC_VECTOR(2 downto 0);
		sel_distY					: in STD_LOGIC_VECTOR(2 downto 0);
		sel_candidates				: in STD_LOGIC_VECTOR(1 downto 0);
		chooseMode					: in STD_LOGIC;
		loadregNumPUsLevel		: in STD_LOGIC;
		op_typeX						: in STD_LOGIC;
		op_typeY						: in STD_LOGIC;
		incRegCurVecX				: in STD_LOGIC;
		incRegCurVecY				: in STD_LOGIC;
		rstRegCurVecX				: in STD_LOGIC;
		rstRegCurVecY				: in STD_LOGIC;
		incRegNumLevels			: in STD_LOGIC;
		rstRegNumLevels			: in STD_LOGIC;
		initData						: in STD_LOGIC;
		initIncrement				: in STD_LOGIC;
		rstRegPUsFinished			: in STD_LOGIC;
		sendToMem					: in STD_LOGIC;
		loadCurVec					: in STD_LOGIC;
		loadByPassOutOfAnyBound : in STD_LOGIC;
		incRegPUsFinished			: in STD_LOGIC;
		loadByPassVecFound		: in STD_LOGIC;
		writeCache					: in STD_LOGIC;
		searchRange					: in STD_LOGIC_VECTOR(7 downto 0);
		vecFound						: out STD_LOGIC;
		byPassVecFound				: out STD_LOGIC;
		isOutOfAnyBound			: out STD_LOGIC;
		byPassIsOutOfAnyBound	: out STD_LOGIC;
		hasPassedNumLevels		: out STD_LOGIC;
		doAgain						: out STD_LOGIC_VECTOR(2 downto 0);
		finishSendPartitions		: out STD_LOGIC;
		vecMemX						: out STD_LOGIC_VECTOR(7 downto 0);
		vecMemY						: out STD_LOGIC_VECTOR(7 downto 0);
		bestVecX						: out STD_LOGIC_VECTOR(7 downto 0);
		bestVecY						: out STD_LOGIC_VECTOR(7 downto 0)
	);
end Datapath_FirstSearch;

architecture Behavioral of Datapath_FirstSearch is


signal middleSubResult, middleNrAccumSubSrc: STD_LOGIC;

--signal reg_iDist: STD_LOGIC_VECTOR(7 downto 0);
signal regSearchRange: STD_LOGIC_VECTOR(7 downto 0);
signal numLevels, regNumLevels, regMode: STD_LOGIC_VECTOR(1 downto 0);
signal regCurVecX, regCurVecY: STD_LOGIC_VECTOR(7 downto 0);
signal regBestX, regBestY: STD_LOGIC_VECTOR(7 downto 0);
signal regCenterX, regCenterY: STD_LOGIC_VECTOR(7 downto 0);
signal regBestSAD: STD_LOGIC_VECTOR(19 downto 0);
signal regBorderLeft, regBorderRight, regBorderUp, regBorderDown: STD_LOGIC_VECTOR(7 downto 0);
signal subRight, subDown: STD_LOGIC_VECTOR(7 downto 0);
signal auxRegBorderDown, auxRegBorderRight: STD_LOGIC_VECTOR(7 downto 0);
--signal isOutOfXBound, isOutOfYBound: STD_LOGIC;
signal regDifferenceSADs, differenceSADs: STD_LOGIC_VECTOR(19 downto 0);
signal S_SAD: STD_LOGIC_VECTOR(19 downto 0);
signal doneRest: STD_LOGIC;
signal SAD441, SAD442, SAD443, SAD444: STD_LOGIC_VECTOR(11 downto 0);
signal SAD481, SAD482: STD_LOGIC_VECTOR(12 downto 0);
signal done: STD_LOGIC;
signal sumValueX, sumValueY: STD_LOGIC_VECTOR(7 downto 0);
signal auxCurVecX, auxCurVecY: STD_LOGIC_VECTOR(7 downto 0);
signal multHW: STD_LOGIC_VECTOR(13 downto 0);
signal latency, regLatency, regSubLatency, subLatency: STD_LOGIC_VECTOR(7 downto 0);

signal regDoAgain: STD_LOGIC_VECTOR(2 downto 0);

signal regCurCenterX, regCurCenterY: STD_LOGIC_VECTOR(7 downto 0);
signal betterSAD: STD_LOGIC;

signal regPUsFinished: STD_LOGIC_VECTOR(4 downto 0);
signal regLoadedBetter: STD_LOGIC;

signal regVecMemX, regVecMemY: STD_LOGIC_VECTOR(7 downto 0);
signal regByPassCurVecX, regByPassCurVecY: STD_LOGIC_VECTOR(7 downto 0);

--signal auxIs8x8or16x4, regIs8x8or16x4: STD_LOGIC;
signal regIsOutOfAnyBound, auxIsOutOfAnyBound, regIsOutOfAnyBoundByPass: STD_LOGIC;

signal regCurVecXByPass1, regCurVecXByPass2, regCurVecXByPass3, regCurVecXByPass4, regCurVecXByPass5, regCurVecXByPass6,
 regCurVecXByPass7, regCurVecXByPass8, regCurVecXByPass9, regCurVecXByPass10: STD_LOGIC_VECTOR(7 downto 0);
signal regCurVecYByPass1, regCurVecYByPass2, regCurVecYByPass3, regCurVecYByPass4, regCurVecYByPass5, regCurVecYByPass6,
 regCurVecYByPass7, regCurVecYByPass8, regCurVecYByPass9, regCurVecYByPass10: STD_LOGIC_VECTOR(7 downto 0);

signal dirtyBitByPass1, dirtyBitByPass2, dirtyBitByPass3, dirtyBitByPass4, dirtyBitByPass5, dirtyBitByPass6, dirtyBitByPass7,
dirtyBitByPass8, dirtyBitByPass9, dirtyBitByPass10: STD_LOGIC;

signal middleValidSAD: STD_LOGIC;

signal regNumPUsLevel: STD_LOGIC_VECTOR(4 downto 0);

signal numCandidatesLevel: STD_LOGIC_VECTOR(4 downto 0);

signal auxDiffRegPUsLevel: STD_LOGIC_VECTOR(4 downto 0);
signal hasPassedPUsLevel: STD_LOGIC;
signal auxVecFound, regByPassVecFound: STD_LOGIC;

	component CircularBuffer_Datapath
	Port(
		CLK			: in STD_LOGIC;
		START			: in STD_LOGIC;
		writeCache	: in STD_LOGIC;
		curVecX		: in STD_LOGIC_VECTOR(7 downto 0);
		curVecY		: in STD_LOGIC_VECTOR(7 downto 0);
		vecFound		: out STD_LOGIC
	);
	end component;

begin

multHW <= heightPU * widthPU;
latency <= ('0' & multHW (12 downto 6)) - 1;
						
finishSendPartitions <= regSubLatency(7);


sumValueX <= "00000001" when sel_distX = "000" else
				"00000010" when sel_distX = "001" else
				"00000100" when sel_distX = "010" else
				"00001000" when sel_distX = "011" else
				"00001100" when sel_distX = "100" else
				"00010000" when sel_distX = "101" else
				"00011000" when sel_distX = "110" else
				"00100000";
				
--SEL_DIST 0 => 1
--SEL_DIST 1 => 2
--SEL_DIST 2 => 4
--SEL_DIST 3 => 8
--SEL_DIST 4 => 12
--SEL_DIST 5 => 16
--SEL_DIST 6 => 24
--SEL_DIST 7 => 32

sumValueY <= "00000001" when sel_distY = "000" else
				"00000010" when sel_distY = "001" else
				"00000100" when sel_distY = "010" else
				"00001000" when sel_distY = "011" else
				"00001100" when sel_distY = "100" else
				"00010000" when sel_distY = "101" else
				"00011000" when sel_distY = "110" else
				"00100000";
				
auxCurVecX <= regCurVecX + sumValueX when op_typeX = '1' else
				  regCurVecX - sumValueX;

auxCurVecY <= regCurVecY + sumValueY when op_typeY = '1' else
				  regCurVecY - sumValueY;
				  
-- OP_TYPE = 1 -> SOMA
-- OP_TYPE = 0 -> SUBTRAÇÃO

numCandidatesLevel <= "00100" when sel_candidates = "00" else
							 "01000" when sel_candidates = "01" else
							 "10000" when sel_candidates = "10" else
							 "11111";

vecMemX 			<= regVecMemX;
vecMemY 			<= regVecMemY;
bestVecX 		<= regBestX;
bestVecY 		<= regBestY;
doAgain 			<= regDoAgain;
--is8x8or16x4 	<= regIs8x8or16x4;
byPassVecFound <= regByPassVecFound;
vecFound			<= auxVecFound;

hasPassedNumLevels <= '1' when regNumLevels = regMode else
							 '0';
							 
-- auxDiffRegPUsLevel <= regNumPUsLevel - regPUsFinished;

hasPassedPUsLevel <= '1' when regNumPUsLevel = regPUsFinished else
							'0';

numLevels <= regNumLevels + 1 when incRegNumLevels = '1' and regLoadedBetter = '0' else
				 "00" when regLoadedBetter = '1' else
				 regNumLevels;

--isOutOfXBound <= '1' when regSubRight(7) = '1' else
--					  '0';
--
--isOutOfYBound <= '1' when regSubDown(7) = '1' else
--					  '0';

auxIsOutOfAnyBound <= '1' when subRight(7) = '0' or subDown(7) = '0' else
						 '0';

isOutOfAnyBound <= regIsOutOfAnyBound;
byPassIsOutOfAnyBound <= regIsOutOfAnyBoundByPass;
--betterSAD <= '1' when regDifferenceSADs(19) = '1' else
--				 '0';
				 
subRight <= regCurVecX - regBorderRight;
subDown <= regCurVecY - regBorderDown;

	process(CLK, START)
	begin
		if(START = '0') then
		
			regMode <= (OTHERS=>'0');
			
--			regIs8x8or16x4 <= '0';
			regLatency <= (OTHERS=>'0');
			regSubLatency <= (OTHERS=>'0');
			regSearchRange <= (OTHERS => '0');

			regCurVecX <= (OTHERS=>'0');
			regCurVecY <= (OTHERS=>'0');
			regBorderLeft <= (OTHERS=>'0');
			regBorderRight <= (OTHERS=>'0');
			regBorderUp	<= (OTHERS=>'0');
			regBorderDown <= (OTHERS=>'0');
			regNumLevels <= (OTHERS=>'0');
			regPUsFinished <= (OTHERS=>'0');
			
			regLoadedBetter <= '0';
			regDifferenceSADs <= (OTHERS=>'0');
			auxRegBorderRight <= (OTHERS=>'0');
			auxRegBorderDown <= (OTHERS=>'0');
			regBestX <= (OTHERS=>'0');
			regBestY <= (OTHERS=>'0');
			regCenterX <= (OTHERS=>'0');
			regCenterY <= (OTHERS=>'0');
			
			regCurCenterX <= (OTHERS=>'0');
			regCurCenterY <= (OTHERS=>'0');
			regByPassCurVecX <= (OTHERS=>'0');
			regByPassCurVecY <= (OTHERS=>'0');
			regIsOutOfAnyBound <= '0';
			regIsOutOfAnyBoundByPass <= '0';
			
			regVecMemX <= (OTHERS=>'0');
			regVecMemY <= (OTHERS=>'0');

			regNumPUsLevel <= (OTHERS=>'0');
			
			regDoAgain <= (OTHERS=>'0');
			
			regByPassVecFound <= '0';
		elsif(CLK'event and CLK = '1') then
			regLatency <= latency;

			regSearchRange <= searchRange; -- OK
--			regCenterX <= initCenterX;
--			regCenterY <= initCenterY;
			
			regNumLevels <= numLevels;
			
			regBorderLeft <= initCenterX - regSearchRange; -- OK
			regBorderUp <= initCenterY - regSearchRange; -- OK
			
			auxRegBorderRight <= initCenterX + regSearchRange; 
			auxRegBorderDown <= initCenterY + regSearchRange;
			
			regBorderRight <= auxRegBorderRight - widthPU + 1;
			regBorderDown <= auxRegBorderDown - heightPU + 1;
						
			if(loadByPassVecFound = '1') then
				regByPassVecFound <= auxVecFound;
			end if;
			
			if(incDoAgain = '1') then
				regDoAgain <= regDoAgain + 1;
			end if;
			
			if(chooseMode = '0') then
				regMode <= "10";
			else
				regMode <= "11";
			end if;
			
			if(initData = '1') then
				regCurVecX <= initCenterX;
				regCurVecY <= initCenterY;
				regCurCenterX <= initCenterX;
				regCurCenterY <= initCenterY;
				regBestX <= initCenterX;
				regBestY <= initCenterY;
				regSubLatency <= regLatency;
--				regIs8x8or16x4 <= auxIs8x8or16x4;
--				regVecMemX <= initCenterX;
--				regVecMemY <= initCenterY;
--				regByPassCurVecX <= initCenterX;
--				regByPassCurVecY <= initCenterY;
--				regSubRight <= (OTHERS=>'1');
--				regSubDown <= (OTHERS=>'1');
			end if;
			
			if(sendToMem = '1') then
				regVecMemX <= regByPassCurVecX;
				regVecMemY <= regByPassCurVecY;
			end if;

			if(loadCurVec = '1') then
				regByPassCurVecX <= regCurVecX;
				regByPassCurVecY <= regCurVecY;
				regIsOutOfAnyBound <= auxIsOutOfAnyBound;
--				regSubRight <= regCurVecX - regBorderRight;
--				regSubDown <= regCurVecY - regBorderDown;
			end if;
			
			if(loadregNumPUsLevel = '1') then
				regNumPUsLevel <= numCandidatesLevel;
			end if;
			
			if(loadByPassOutOfAnyBound = '1') then
				regIsOutOfAnyBoundByPass <= regIsOutOfAnyBound;
			end if;
			
			if(initIncrement = '1') then
				regSubLatency <= subLatency - 1;
			else
				regSubLatency <= regLatency;
			end if;
			
			if(incRegCurVecX = '1') then
				regCurVecX <= auxCurVecX;
			end if;
			
			if(incRegCurVecY = '1') then
				regCurVecY <= auxCurVecY;
			end if;
			
			if(rstRegCurVecX = '1') then
				regCurVecX <= regCurCenterX;
			end if;

			if(rstRegCurVecY = '1') then
				regCurVecY <= regCurCenterY;
			end if;
			
			if(foundBetterSAD = '1') then
				regBestX <= regCurVecXByPass10;
				regBestY <= regCurVecYByPass10;
				regLoadedBetter <= '1';
			end if;
		
--			if(incRegNumLevels = '1') then
--				regNumLevels <= regNumLevels + 1;
--			end if;
--			
--			if(rstRegNumLevels = '1') then
--				regNumLevels <= (OTHERS=>'0');
--			end if;
			
--			if(inc_iDist = '1') then
--				reg_iDist <= reg_iDist(7 downto 1) & '0';
--			end if;
			
			if(incRegPUsFinished = '1' or doneRest = '1') then
				regPUsFinished <= regPUsFinished + 1;
			end if;
			
			if(hasPassedPUsLevel = '1') then
				regCurCenterX <= regBestX;
				regCurCenterY <= regBestY;
			end if;
			
			if(rstRegPUsFinished = '1') then
				regPUsFinished <= (OTHERS=>'0');
				regLoadedBetter <= '0';
			end if;
			
		end if;
	end process;

	with regSubLatency(7) select
		subLatency <= regLatency when '1',
						  regSubLatency when OTHERS;
						  





	Inst_Circ_Buffer: CircularBuffer_Datapath PORT MAP(
		CLK				=> CLK,
		START				=> START,
		writeCache		=> writeCache,
		curVecX			=> regCurVecX,
		curVecY			=> regCurVecY,
		vecFound			=> auxVecFound
	);








	process(CLK, START)
	begin
		if(START = '0') then
			regCurVecXByPass1 <= (OTHERS=>'0');
			regCurVecXByPass2 <= (OTHERS=>'0');
			regCurVecXByPass3 <= (OTHERS=>'0');
			regCurVecXByPass4 <= (OTHERS=>'0');
			regCurVecXByPass5 <= (OTHERS=>'0');
			regCurVecXByPass6 <= (OTHERS=>'0');
			regCurVecXByPass7 <= (OTHERS=>'0');
			regCurVecXByPass8 <= (OTHERS=>'0');
			regCurVecXByPass9 <= (OTHERS=>'0');
			regCurVecXByPass10 <= (OTHERS=>'0');
			regCurVecYByPass1 <= (OTHERS=>'0');
			regCurVecYByPass2 <= (OTHERS=>'0');
			regCurVecYByPass3 <= (OTHERS=>'0');
			regCurVecYByPass4 <= (OTHERS=>'0');
			regCurVecYByPass5 <= (OTHERS=>'0');
			regCurVecYByPass6 <= (OTHERS=>'0');
			regCurVecYByPass7 <= (OTHERS=>'0');
			regCurVecYByPass8 <= (OTHERS=>'0');
			regCurVecYByPass9 <= (OTHERS=>'0');
			regCurVecYByPass10 <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			regCurVecXByPass1 	<= regCurVecX;
			regCurVecXByPass2 	<= regCurVecXByPass1;
			regCurVecXByPass3 	<= regCurVecXByPass2;
			regCurVecXByPass4 	<= regCurVecXByPass3;
			regCurVecXByPass5 	<= regCurVecXByPass4;
			regCurVecXByPass6 	<= regCurVecXByPass5;
			regCurVecXByPass7 	<= regCurVecXByPass6;
			regCurVecXByPass8 	<= regCurVecXByPass7;
			regCurVecXByPass9 	<= regCurVecXByPass8;
			regCurVecXByPass10 	<= regCurVecXByPass9;
			
			regCurVecYByPass1 	<= regCurVecY;
			regCurVecYByPass2 	<= regCurVecYByPass1;
			regCurVecYByPass3 	<= regCurVecYByPass2;
			regCurVecYByPass4 	<= regCurVecYByPass3;
			regCurVecYByPass5 	<= regCurVecYByPass4;
			regCurVecYByPass6 	<= regCurVecYByPass5;
			regCurVecYByPass7 	<= regCurVecYByPass6;
			regCurVecYByPass8 	<= regCurVecYByPass7;
			regCurVecYByPass9 	<= regCurVecYByPass8;
			regCurVecYByPass10 	<= regCurVecYByPass9;
		end if;
	end process;

end Behavioral;

