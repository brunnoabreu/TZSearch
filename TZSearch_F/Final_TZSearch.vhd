----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:50:28 09/09/2015 
-- Design Name: 
-- Module Name:    Final_TZSearch - Behavioral 
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

entity Final_TZSearch is
	Port(
		CLK				: in STD_LOGIC;
		GLOBAL_START	: in STD_LOGIC;
		matA1				: in matrixSAD;
		matA2				: in matrixSAD;
		matA3				: in matrixSAD;
		matA4				: in matrixSAD;
		matB1				: in matrixSAD;
		matB2				: in matrixSAD;
		matB3				: in matrixSAD;
		matB4				: in matrixSAD;
		heightPU			: in STD_LOGIC_VECTOR(6 downto 0);
		widthPU			: in STD_LOGIC_VECTOR(6 downto 0);
		searchRange		: in STD_LOGIC_VECTOR(7 downto 0);
		initCandidateX	: in STD_LOGIC_VECTOR(7 downto 0); --CANDIDATOS ENVIADOS DE FORA PARA SEREM ESCOLHIDOS COMO O CENTRO
		initCandidateY	: in STD_LOGIC_VECTOR(7 downto 0);
		curVecX			: out STD_LOGIC_VECTOR(7 downto 0); --VETORES A SEREM ENVIADOS PARA A MEMÓRIA (PARA BUSCA)
		curVecY			: out STD_LOGIC_VECTOR(7 downto 0);
		bestVecX			: out STD_LOGIC_VECTOR(7 downto 0); --MELHOR VETOR
		bestVecY			: out STD_LOGIC_VECTOR(7 downto 0);
		done				: out STD_LOGIC
	);
end Final_TZSearch;

architecture Behavioral of Final_TZSearch is

	component Datapath
		Port(
		matA1      			: in matrixSAD;
		matB1      			: in matrixSAD;
		matA2      			: in matrixSAD;
		matB2      			: in matrixSAD;
		matA3      			: in matrixSAD;
		matB3      			: in matrixSAD;
		matA4      			: in matrixSAD;
		matB4      			: in matrixSAD;
		CLK        			: in STD_LOGIC;
		START      			: in STD_LOGIC;
		nrAccum				: in STD_LOGIC_VECTOR(7 downto 0);
		nrAccumSubSrc		: in STD_LOGIC;
		isValidSAD			: in STD_LOGIC;
		subResult			: out STD_LOGIC;
		SAD441				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD442				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD443				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD444				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD481				: out STD_LOGIC_VECTOR(12 downto 0);
		SAD482				: out STD_LOGIC_VECTOR(12 downto 0);
		SAD        			: out STD_LOGIC_VECTOR(19 downto 0)
	);
	end component;
	
	component Datapath_Raster
		Port(
		CLK						: in STD_LOGIC;
		START						: in STD_LOGIC;
	--	foundBetterSAD			: in STD_LOGIC;
		cyclesPerPU				: in STD_LOGIC_VECTOR(7 downto 0);
		borderLeft				: in STD_LOGIC_VECTOR(7 downto 0);
		borderRight				: in STD_LOGIC_VECTOR(7 downto 0);
		borderUp					: in STD_LOGIC_VECTOR(7 downto 0);
		borderDown				: in STD_LOGIC_VECTOR(7 downto 0);
		initData					: in STD_LOGIC;
		initIncrement			: in STD_LOGIC;
		rearrangeVecMems		: in STD_LOGIC;
		incRegX					: in STD_LOGIC;
		loadRegXMem2			: in STD_LOGIC;
		sendToMem				: in STD_LOGIC;
	--	searchRange				: in STD_LOGIC_VECTOR(7 downto 0);
	--	initCenterX				: in STD_LOGIC_VECTOR(7 downto 0);
	--	initCenterY				: in STD_LOGIC_VECTOR(7 downto 0);
		bestInitialX			: in STD_LOGIC_VECTOR(7 downto 0);
		bestInitialY			: in STD_LOGIC_VECTOR(7 downto 0);
		finishSendPartitions	: out STD_LOGIC;
		isOutOfXBound			: out STD_LOGIC;
		isOutOfYBound			: out STD_LOGIC;
		xMem						: out STD_LOGIC_VECTOR(7 downto 0);
		yMem						: out STD_LOGIC_VECTOR(7 downto 0);
		bestVecX					: out STD_LOGIC_VECTOR(7 downto 0);
		bestVecY					: out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	component Datapath_FirstSearch
		Port(
		CLK							: in STD_LOGIC;
		START							: in STD_LOGIC;
		foundBetterSAD				: in STD_LOGIC;
		cyclesPerPU					: in STD_LOGIC_VECTOR(7 downto 0);
		borderLeft					: in STD_LOGIC_VECTOR(7 downto 0);
		borderRight					: in STD_LOGIC_VECTOR(7 downto 0);
		borderUp						: in STD_LOGIC_VECTOR(7 downto 0);
		borderDown					: in STD_LOGIC_VECTOR(7 downto 0);
		initCenterX					: in STD_LOGIC_VECTOR(7 downto 0);
		initCenterY					: in STD_LOGIC_VECTOR(7 downto 0);
		incDoAgain					: in STD_LOGIC;
		donePU						: in STD_LOGIC;
		sel_distX					: in STD_LOGIC_VECTOR(2 downto 0);
		sel_distY					: in STD_LOGIC_VECTOR(2 downto 0);
		sel_candidates				: in STD_LOGIC_VECTOR(1 downto 0);
		isRefinement				: in STD_LOGIC;
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
		loadVecFound				: in STD_LOGIC;
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
	end component;
	
	component UC_PredMov
		Port(
		CLK					: in STD_LOGIC;
		START					: in STD_LOGIC;
		doneSAD				: in STD_LOGIC;
		START2				: out STD_LOGIC;
		validBit				: out STD_LOGIC;
		done					: out STD_LOGIC
	);
	end component;
	
	component UC_Raster
		Port(
		CLK						: in STD_LOGIC;
		START						: in STD_LOGIC;
		finishSendPartitions	: in STD_LOGIC;
		isOutOfXBound			: in STD_LOGIC;
		isOutOfYBound			: in STD_LOGIC;
		START2					: out STD_LOGIC;
		initData					: out STD_LOGIC;
		initIncrement			: out STD_LOGIC;
		incRegX					: out STD_LOGIC;
		rearrangeVecMems		: out STD_LOGIC;
		waitCycles				: out STD_LOGIC;
		validBit					: out STD_LOGIC;
		loadRegXMem2			: out STD_LOGIC;
		sendToMem				: out STD_LOGIC;
		done						: out STD_LOGIC
	);
	end component;

	component UC_SAD
		Port(
		CLK         		: in STD_LOGIC;
		START       		: in STD_LOGIC;
		waitCycles			: in STD_LOGIC;
		is8x8or16x4			: in STD_LOGIC;
		subResult			: in STD_LOGIC;
		validBit				: in STD_LOGIC;
		nrAccumSubSrc		: out STD_LOGIC;
		doneRest				: out STD_LOGIC
		);
	end component;
	
	component UC_MainFirst
		Port(
		CLK							: in STD_LOGIC;
		START							: in STD_LOGIC;
		finishSendPartitions		: in STD_LOGIC;
		doAgain						: in STD_LOGIC_VECTOR(2 downto 0);
		inpDonePU					: in STD_LOGIC;
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
		outDonePU					: out STD_LOGIC;
		START2						: out STD_LOGIC;
		waitCycles					: out STD_LOGIC;
		validBit						: out STD_LOGIC;
		done							: out STD_LOGIC
	);	
	end component;
	
	component UC_TZSearch
		Port(
		CLK					: in STD_LOGIC;
		START					: in STD_LOGIC;
		donePredMov			: in STD_LOGIC;
		doneFirstSearch	: in STD_LOGIC;
		doneRaster			: in STD_LOGIC;
		vecBig				: in STD_LOGIC;
		STARTPredMov		: out STD_LOGIC;
		STARTFirstSearch	: out STD_LOGIC;
		STARTRaster			: out STD_LOGIC;
		loadSearchCenter	: out STD_LOGIC;
		sel_TZ_stage		: out STD_LOGIC_VECTOR(1 downto 0);
		done					: out STD_LOGIC
	);
	end component;
		
	---------- C O R E    G E N  ------------------------------------
	
	COMPONENT mult_core
  PORT (
    clk : IN STD_LOGIC;
    a : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    b : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    p : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
  );
END COMPONENT;

	-----------------------------------------------------------------
	
	
signal middleWaitCycles, middleSubResult,  
middlevalidBit, middleNrAccumSubSrc : STD_LOGIC;
signal S_SAD, regBestSAD: STD_LOGIC_VECTOR(19 downto 0);
signal doneRest: STD_LOGIC;
signal auxIs8x8or16x4, foundBetterSAD, flagBetter, regis8x8or16x4: STD_LOGIC;
signal loadsearchcenter: STD_LOGIC;
signal muxstart2: STD_LOGIC;
signal regCenterx, regCenterY, regBestVecX, regBestVecY: STD_LOGIC_VECTOR(7 downto 0);
signal auxBestVecX, auxBestVecY: STD_LOGIC_VECTOR(7 downto 0);

signal STARTFirstSearch, START2FirstSearch, middleInitData_FirstSearch, middleInitIncrement_FirstSearch: STD_LOGIC;
signal waitCycles_FirstSearch, validBit_FirstSearch, doneFirstSearch, middleSendToMem_Firstsearch: STD_LOGIC;
signal middleVecMemX_FirstSearch, middleVecMemY_FirstSearch, middleBestVecX_FirstSearch, middleBestVecY_FirstSearch: STD_LOGIC_VECTOR(7 downto 0);

signal STARTRaster, START2Raster, middleFinishSendPartitions_Raster, middleIsOutOfXBound, middleIsOutOfYBound, doneRaster: STD_LOGIC;
signal middleInitData_Raster, middleInitIncrement_Raster, waitCycles_Raster, validBit_Raster, middleSendToMem_Raster: STD_LOGIC;
signal middleVecMemX_Raster, middleVecMemY_Raster, middleBestVecX_Raster, middleBestVecY_Raster: STD_LOGIC_VECTOR(7 downto 0);

signal middleOutDonePU: STD_LOGIC;
signal STARTPredMov, START2PredMov, validBit_PredMov, donePredMov: STD_LOGIC;
signal middleIncRegX, middleRearrangeVecMems, middleLoadRegXMem2: STD_LOGIC;
signal middleFinishSendPartitions_FirstSearch, middleIsOutOfAnyBound, middleByPassIsOutOfAnyBound, middleLoadVecFound, middleLoadByPassVecFound, middleLoadByPassOutOfAnyBound: STD_LOGIC;
signal middleHasPassedNumLevels, middleVecFound, middleByPassVecFound: STD_LOGIC;
signal middleDoAgain: STD_LOGIC_VECTOR(2 downto 0);
signal middleWriteCache: STD_LOGIC;
signal middleLoadCurVec, middleRstRegPUsFinished: STD_LOGIC;
signal middleIncDoAgain: STD_LOGIC;
signal middleSel_distX, middleSel_distY: STD_LOGIC_VECTOR(2 downto 0);
signal middleSel_candidates: STD_LOGIC_VECTOR(1 downto 0);
signal middleLoadRegNumPUsLevel, middleIncRegPUsFinished: STD_LOGIC;
signal middleOp_typeX, middleOp_typeY: STD_LOGIC;
signal middleIncRegCurVecX, middleIncRegCurVecY, middleRstRegCurVecX, middleRstRegCurVecY: STD_LOGIC;
signal middleIncRegNumLevels, middleRstRegNumLevels: STD_LOGIC;
signal loadCenter: STD_LOGIC;

signal regHeightPU, regWidthPU: STD_LOGIC_VECTOR(6 downto 0);

signal sel_TZ_stage: STD_LOGIC_VECTOR(1 downto 0);

signal invalidBit: STD_LOGIC;

signal validBitByPass1, validBitByPass2, validBitByPass3, validBitByPass4, validBitByPass5, validBitByPass6, validBitByPass7,
validBitByPass8, validBitByPass9, validBitByPass10: STD_LOGIC;
signal inVecX, inVecXByPass1, inVecXByPass2, inVecXByPass3, inVecXByPass4, inVecXByPass5, inVecXByPass6, inVecXByPass7, inVecXByPass8: STD_LOGIC_VECTOR(7 downto 0);
signal inVecY, inVecYByPass1, inVecYByPass2, inVecYByPass3, inVecYByPass4, inVecYByPass5, inVecYByPass6, inVecYByPass7, inVecYByPass8: STD_LOGIC_VECTOR(7 downto 0);

signal cyclesPerPU, regCyclesPerPU: STD_LOGIC_VECTOR(7 downto 0);
signal multHW: STD_LOGIC_VECTOR(13 downto 0);
signal regSearchRange, regBorderLeft, regBorderRight, regBorderUp, regBorderDown, auxRegBorderRight, auxRegBorderDown: STD_LOGIC_VECTOR(7 downto 0);

signal p_subBestVecX, not_p_subBestVecX, p_subBestVecY, not_p_subBestVecY: STD_LOGIC_VECTOR(8 downto 0);
signal subBestVecX, subBestVecY, regSubBestVecX, regSubBestVecY: STD_LOGIC_VECTOR(7 downto 0);
signal vecBig: STD_LOGIC;

begin

--multHW <= regHeightPU * regWidthPU;
cyclesPerPU <= ('0' & multHW (12 downto 6)) - 1;

auxIs8x8or16x4 <= '1' when ((heightPU(3 downto 2) = "10" and widthPU(3 downto 2) = "10") or (heightPU(3 downto 2) = "01" and widthPU(3 downto 2) = "01")) else
						'0';

foundBetterSAD <= '1' when flagBetter = '1' and doneRest = '1' else
						'0';
						
flagBetter <= '1' when S_SAD < regBestSAD else
				  '0';
				  
bestVecX <= regBestVecX;
bestVecY <= regBestVecY;

--isOutOfAnyBound <= isOutOfXBound or isOutOfYBound;
--
--isOutOfXBound <= '1' when subRight(7) = '0' else
--					  '0';
--					  
--isOutOfYBound <= '1' when subDown(7) = '0' else
--					  '0';
--
--subRight <= muxVecs_RegX - regBorderRight;
--subDown <= muxVecs_RegY - regBorderDown;

loadCenter <= foundBetterSAD and loadSearchCenter;

p_subBestVecX <= ('0' & regBestVecX) - ('0' & regCenterX);
not_p_subBestVecX <= ('0' & regCenterX) - ('0' & regBestVecX);
p_subBestVecY <= ('0' & regBestVecY) - ('0' & regCenterY);
not_p_subBestVecY <= ('0' & regCenterY) - ('0' & regBestVecY);

with p_subBestVecX(8) select
	subBestVecX <= p_subBestVecX(7 downto 0) when '0',
	     not_p_subBestVecX(7 downto 0) when OTHERS;
		  
with p_subBestVecY(8) select
	subBestVecY <= p_subBestVecY(7 downto 0) when '0',
	     not_p_subBestVecY(7 downto 0) when OTHERS;

vecBig <= '0' when (regSubBestVecX < 3 and regSubBestVecY < 4) or (regSubBestVecX < 4 and regSubBestVecY < 3) else
			 '1';

	process(CLK, GLOBAL_START, loadCenter, foundBetterSAD)
	begin
		if(GLOBAL_START='0') then
			regCyclesPerPU <= (OTHERS=>'0');
			regHeightPU <= (OTHERS=>'0');
			regWidthPU <= (OTHERS=>'0');
			regIs8x8or16x4 <= '0';
			regBestSAD <= (OTHERS=>'1');
			regCenterX <= (OTHERS=>'0');
			regCenterY <= (OTHERS=>'0');
			regBestVecX <= (OTHERS=>'0');
			regBestVecY <= (OTHERS=>'0');
			regSearchRange <= (OTHERS=>'0');
			regBorderLeft <= (OTHERS=>'0');
			regBorderRight <= (OTHERS=>'0');
			regBorderUp <= (OTHERS=>'0');
			regBorderDown <= (OTHERS=>'0');
			auxRegBorderRight <= (OTHERS=>'0');
			auxRegBorderDown <= (OTHERS=>'0');
			regSubBestVecX <= (OTHERS=>'0');
			regSubBestVecY <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			regIs8x8or16x4 <= auxIs8x8or16x4;
			regHeightPU <= heightPU;
			regWidthPU <= widthPU;
			regCyclesPerPU <= cyclesPerPU;
			
			regSubBestVecX <= subBestVecX;
			regSubBestVecY <= subBestVecY;
			
			if(foundBetterSAD = '1') then
				regBestSAD <= S_SAD;
			end if;
			
			if(loadCenter = '1') then
				regCenterX <= inVecXByPass8;
				regCenterY <= inVecYByPass8;
			end if;
			
			if(foundBetterSAD = '1') then
				regBestVecX <= auxBestVecX;
				regBestVecY <= auxBestVecY;
			end if;
			
			regSearchRange <= searchRange;
			regBorderLeft <= regCenterX - regSearchRange;
			regBorderUp <= regCenterY - regSearchRange;
			
			auxRegBorderRight <= regSearchRange - regWidthPU;
			auxRegBorderDown <= regSearchRange - regHeightPU;
		
			regBorderRight <= auxRegBorderRight + regCenterX;
			regBorderDown <= auxRegBorderDown + regCenterY;
		end if;
	end process;
	
----------------------------------------------------------------
 -- C O R E     G E N  -----	
MULT_CORE_GEN : mult_core
  PORT MAP (
    clk => clk,
    a => regWidthPU,
    b => regHeightPU,
    p => multHW
  );
  
  ----------------------------------------------------------------
	
	Inst_Datapath: Datapath Port Map(
		matA1 			=> matA1, --OK
		matB1 			=> matB1, --OK
		matA2 			=> matA2, --OK
		matB2 			=> matB2, --OK
		matA3 			=> matA3, --OK
		matB3 			=> matB3, --OK
		matA4 			=> matA4, --OK
		matB4 			=> matB4, --OK 
		CLK 				=> CLK, --OK
		START 			=> GLOBAL_START, --OK
		nrAccum			=> regCyclesPerPU, --OK
		nrAccumSubSrc 	=> middleNrAccumSubSrc, --OK
		isValidSAD		=> middlevalidBit, --OK
		subResult 		=> middleSubResult, --OK
		SAD 				=> S_SAD --OK
	);

	Inst_SAD_UC: UC_SAD PORT MAP(
		CLK 			  	=> CLK, --OK
		START 		  	=> muxSTART2, --OK
		waitCycles	  	=> middleWaitCycles, --OK
		is8x8or16x4		=> regIs8x8or16x4, --OK
		subResult 	  	=> middleSubResult, --OK
		validBit			=> middlevalidBit, --OK
		nrAccumSubSrc 	=> middleNrAccumSubSrc, --OK
		doneRest 	  	=> doneRest --OK
	);
	
	Inst_UC_MainFirst: UC_MainFirst PORT MAP(
		CLK							=> CLK, --OK
		START							=> STARTFirstSearch, --OK
		finishSendPartitions		=> middleFinishSendPartitions_FirstSearch, --OK
		doAgain						=> middleDoAgain, --OK
		inpDonePU					=> doneRest, 
		is8x8or16x4					=> regIs8x8or16x4,
		isOutOfAnyBound			=> middleIsOutOfAnyBound, --OK
		byPassIsOutOfAnyBound	=> middleByPassIsOutOfAnyBound, --OK
		hasPassedNumLevels		=> middleHasPassedNumLevels, --OK
		vecFound						=> middleVecFound, --OK
		byPassVecFound				=> middleByPassVecFound, --OK
		loadVecFound				=> middleLoadVecFound, --OK
		loadByPassVecFound		=> middleLoadByPassVecFound, --OK
		writeCache					=> middleWriteCache, --OK
		loadCurVec					=> middleLoadCurVec, --OK
		loadByPassOutOfAnyBound => middleLoadByPassOutOfAnyBound, --OK
		sendToMem					=> middleSendToMem_FirstSearch, --OK
		rstRegPUsFinished			=> middleRstRegPUsFinished, --OK
		incDoAgain					=> middleIncDoAgain, --OK
		sel_distX					=> middleSel_distX, --OK
		sel_distY					=> middleSel_distY, --OK
		sel_candidates				=> middleSel_candidates, --OK
		loadregNumPUsLevel		=> middleLoadRegNumPUsLevel, --OK
		incRegPUsFinished			=> middleIncRegPUsFinished, --OK
		op_typeX						=> middleOp_typeX, --OK
		op_typeY						=> middleOp_typeY, --OK
		incRegCurVecX				=> middleIncRegCurVecX, --OK
		incRegCurVecY				=> middleIncRegCurVecY, --OK
		rstRegCurVecX				=> middleRstRegCurVecX, --OK
		rstRegCurVecY				=> middleRstRegCurVecY, --OK
		incRegNumLevels			=> middleIncRegNumLevels, --OK
		rstRegNumLevels			=> middleRstRegNumLevels, --OK
		initData						=> middleInitData_FirstSearch, --OK
		initIncrement				=> middleInitIncrement_FirstSearch, --OK
		START2						=> START2FirstSearch, --OK
		outDonePU					=> middleOutDonePU,
		waitCycles					=> waitCycles_FirstSearch, --OK
		validBit						=> validBit_FirstSearch, --OK
		done							=> doneFirstSearch --OK
	);

	
	Inst_UC_Raster: UC_Raster PORT MAP(
		CLK						=> CLK, --OK
		START						=> STARTRaster, --OK
		finishSendPartitions => middleFinishSendPartitions_Raster, --OK
		isOutOfXBound			=> middleIsOutOfXBound, --OK
		isOutOfYBound			=> middleIsOutOfYBound, --OK
		START2					=> START2Raster, --OK
		initData					=> middleInitData_Raster, --OK
		initIncrement			=> middleInitIncrement_Raster, --OK
		incRegX					=> middleIncRegX, --OK
		rearrangeVecMems		=> middleRearrangeVecMems, --OK
		waitCycles				=> waitCycles_Raster, --OK
		validBit					=> validBit_Raster, --OK
		loadRegXMem2			=> middleLoadRegXMem2, --OK
		sendToMem				=> middleSendToMem_Raster, --OK
		done						=> doneRaster --OK
	);	


	Inst_UC_PredMov: UC_PredMov PORT MAP(
		CLK 					=> CLK, --OK
		START 				=> STARTPredMov, --OK
		doneSAD 				=> doneRest, --OK
		START2  				=> START2PredMov, --OK
		validBit				=> validBit_PredMov, --OK
		done 					=> donePredMov --OK
	);
	
	Inst_Datapath_FirstSearch: Datapath_FirstSearch PORT MAP(
			CLK							=> CLK, --OK
			START							=> STARTFirstSearch, --OK
			foundBetterSAD				=> foundBetterSAD, --OK
			cyclesPerPU					=> regCyclesPerPU, --OK
			borderLeft					=> regBorderLeft,
			borderRight					=> regBorderRight,
			borderUp						=> regBorderUp,
			borderDown					=> regBorderDown,
--			initCenterX					=> regCenterX, --OK
--			initCenterY					=> regCenterY, --OK
			initCenterX					=> regBestVecX, --???
			initCenterY					=> regBestVecY, --???
			incDoAgain					=> middleIncDoAgain, --OK
			donePU						=> middleOutDonePU,
			sel_distX					=> middleSel_distX, --OK
			sel_distY					=> middleSel_distY, --OK
			sel_candidates				=> middleSel_candidates, --OK
			isRefinement				=> sel_TZ_stage(1), --OK
			loadregNumPUsLevel		=> middleLoadRegNumPUsLevel, --OK
			op_typeX						=> middleOp_typeX, --OK
			op_typeY						=> middleOp_typeY, --OK
			incRegCurVecX				=> middleIncRegCurVecX, --OK
			incRegCurVecY				=> middleIncRegCurVecY, --OK
			rstRegCurVecX				=> middleRstRegCurVecX, --OK
			rstRegCurVecY				=> middleRstRegCurVecY, --OK
			incRegNumLevels			=> middleIncRegNumLevels, --OK
			rstRegNumLevels			=> middleRstRegNumLevels, --OK
			initData						=> middleInitData_FirstSearch, --OK
			initIncrement				=> middleInitIncrement_FirstSearch, --OK
			rstRegPUsFinished			=> middleRstRegPUsFinished, --OK
			sendToMem					=> middleSendToMem_FirstSearch, --OK
			loadCurVec					=> middleLoadCurVec, --OK
			loadByPassOutOfAnyBound => middleLoadByPassOutOfAnyBound, --OK
			incRegPUsFinished			=> middleIncRegPUsFinished, --OK
			loadVecFound				=> middleLoadVecFound, --OK
			loadByPassVecFound		=> middleLoadByPassVecFound, --OK
			writeCache					=> middleWriteCache, --OK
			searchRange					=> regSearchRange, --OK
			vecFound						=> middleVecFound, --OK
			byPassVecFound				=> middleByPassVecFound, --OK
			isOutOfAnyBound			=> middleIsOutOfAnyBound, --OK
			byPassIsOutOfAnyBound	=> middleByPassIsOutOfAnyBound, --OK
			hasPassedNumLevels		=> middleHasPassedNumLevels, --OK
			doAgain						=> middleDoAgain, --OK
			finishSendPartitions		=> middleFinishSendPartitions_FirstSearch, --OK
			vecMemX						=> middleVecMemX_FirstSearch, --OK
			vecMemY						=> middleVecMemY_FirstSearch, --OK
			bestVecX						=> middleBestVecX_FirstSearch, --OK
			bestVecY						=> middleBestVecY_FirstSearch --OK
			);
			
	
	Inst_Datapath_Raster: Datapath_Raster PORT MAP(
			CLK						=> CLK, --OK
			START						=> STARTRaster, --OK
		--	foundBetterSAD 		=> foundBetterSAD, --OK
			cyclesPerPU				=> regCyclesPerPU, --OK
			borderLeft				=> regBorderLeft, --OK
			borderRight				=> regBorderRight, --OK
			borderUp					=> regBorderUp, --OK
			borderDown				=> regBorderDown, --OK
			initData					=> middleInitData_Raster, --OK
			initIncrement			=> middleInitIncrement_Raster, --OK
			rearrangeVecMems		=> middleRearrangeVecMems, --OK
			incRegX					=> middleIncRegX, --OK
			loadRegXMem2			=> middleLoadRegXMem2, --OK
			sendToMem				=> middleSendToMem_Raster, --OK
		--	searchRange				=> regSearchRange, --OK
		--	initCenterX				=> regCenterX, --OK
		--	initCenterY				=> regCenterY, --OK
			bestInitialX			=> regBestVecX, --OK
			bestInitialY			=> regBestVecY, --OK
			finishSendPartitions	=> middleFinishSendPartitions_Raster, --OK
			isOutOfXBound			=> middleIsOutOfXBound, --OK
			isOutOfYBound			=> middleIsOutOfYBound, --OK
			xMem						=> middleVecMemX_Raster, --OK
			yMem						=> middleVecMemY_Raster, --OK
			bestVecX					=> middleBestVecX_Raster, --OK
			bestVecY					=> middleBestVecY_Raster --OK
	);

	Inst_TZSearch: UC_TZSearch PORT MAP(
		CLK 					=> CLK,
		START 				=> GLOBAL_START,
		donePredMov			=> donePredMov,
		doneFirstSearch 	=> doneFirstSearch,
		doneRaster 			=> doneRaster,
		vecBig				=> vecBig,
		STARTPredMov		=> STARTPredMov,
		STARTFirstSearch	=> STARTFirstSearch,
		STARTRaster			=> STARTRaster,
		loadSearchCenter	=> loadSearchCenter,
		sel_TZ_stage		=> sel_TZ_stage,
		done					=> done
	);


middleWaitCycles <= '0' when sel_TZ_stage = "00" else
						  waitCycles_FirstSearch when sel_TZ_stage = "01" else
						  waitCycles_Raster when sel_TZ_stage = "10" else
						  waitCycles_FirstSearch;
						 

invalidBit <= validBit_PredMov when sel_TZ_stage = "00" else
					   validBit_FirstSearch when sel_TZ_stage = "01" else
						validBit_Raster when sel_TZ_stage = "10" else
						validBit_FirstSearch;


muxSTART2 <= START2PredMov when sel_TZ_stage = "00" else
				 START2FirstSearch when sel_TZ_stage = "01" else
				 START2Raster when sel_TZ_stage = "10" else
				 START2FirstSearch;


curVecX <= middleVecMemX_FirstSearch when sel_TZ_stage = "01" else
			  middleVecMemX_Raster when sel_TZ_stage = "10" else
			  middleVecMemX_FirstSearch when sel_TZ_stage = "11" else
			  (OTHERS=>'0');
				
curVecY <= middleVecMemY_FirstSearch when sel_TZ_stage = "01" else
			  middleVecMemY_Raster when sel_TZ_stage = "10" else
			  middleVecMemY_FirstSearch when sel_TZ_stage = "11" else
			  (OTHERS=>'0');

auxBestVecX <= inVecXByPass8 when sel_TZ_stage = "00" else
					middleBestVecX_FirstSearch when sel_TZ_stage = "01" else
					middleBestVecX_Raster when sel_TZ_stage = "10" else
					middleBestVecX_FirstSearch when sel_TZ_stage = "11" else
					regBestVecX;

auxBestVecY <= inVecYByPass8 when sel_TZ_stage = "00" else
					middleBestVecY_FirstSearch when sel_TZ_stage = "01" else
					middleBestVecY_Raster when sel_TZ_stage = "10" else
					middleBestVecY_FirstSearch when sel_TZ_stage = "11" else
					regBestVecY;

inVecX <= initCandidateX;


inVecY <= initCandidateY;


middlevalidBit <= validBitByPass10;

	process(GLOBAL_START, CLK)
	begin
		if(GLOBAL_START = '0') then
			validBitByPass1 <= '0';
			validBitByPass2 <= '0';
			validBitByPass3 <= '0';
			validBitByPass4 <= '0';
			validBitByPass5 <= '0';
			validBitByPass6 <= '0';
			validBitByPass7 <= '0';
			validBitByPass8 <= '0';
			validBitByPass9 <= '0';
			validBitByPass10 <= '0';
		elsif(CLK'event and CLK='1') then
			validBitByPass1 <= invalidBit;
			validBitByPass2 <= validBitByPass1;
			validBitByPass3 <= validBitByPass2;
			validBitByPass4 <= validBitByPass3;
			validBitByPass5 <= validBitByPass4;
			validBitByPass6 <= validBitByPass5;
			validBitByPass7 <= validBitByPass6;
			validBitByPass8 <= validBitByPass7;
			validBitByPass9 <= validBitByPass8;
			validBitByPass10 <= validBitByPass9;
		end if;
	end process;
	
	process(GLOBAL_START, CLK)
	begin
		if(GLOBAL_START='0') then
			inVecXByPass1 <= (OTHERS=>'0');
			inVecXByPass2 <= (OTHERS=>'0');
			inVecXByPass3 <= (OTHERS=>'0');
			inVecXByPass4 <= (OTHERS=>'0');
			inVecXByPass5 <= (OTHERS=>'0');
			inVecXByPass6 <= (OTHERS=>'0');
			inVecXByPass7 <= (OTHERS=>'0');
			inVecXByPass8 <= (OTHERS=>'0');
			inVecYByPass1 <= (OTHERS=>'0');
			inVecYByPass2 <= (OTHERS=>'0');
			inVecYByPass3 <= (OTHERS=>'0');
			inVecYByPass4 <= (OTHERS=>'0');
			inVecYByPass5 <= (OTHERS=>'0');
			inVecYByPass6 <= (OTHERS=>'0');
			inVecYByPass7 <= (OTHERS=>'0');
			inVecYByPass8 <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			inVecXByPass1 <= inVecX;
			inVecXByPass2 <= inVecXByPass1;
			inVecXByPass3 <= inVecXByPass2;
			inVecXByPass4 <= inVecXByPass3;
			inVecXByPass5 <= inVecXByPass4;
			inVecXByPass6 <= inVecXByPass5;
			inVecXByPass7 <= inVecXByPass6;
			inVecXByPass8 <= inVecXByPass7;
			inVecYByPass1 <= inVecY;
			inVecYByPass2 <= inVecYByPass1;
			inVecYByPass3 <= inVecYByPass2;
			inVecYByPass4 <= inVecYByPass3;
			inVecYByPass5 <= inVecYByPass4;
			inVecYByPass6 <= inVecYByPass5;
			inVecYByPass7 <= inVecYByPass6;
			inVecYByPass8 <= inVecYByPass7;
		end if;
	end process;



end Behavioral;