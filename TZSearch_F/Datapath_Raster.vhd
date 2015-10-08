----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:07:47 07/29/2015 
-- Design Name: 
-- Module Name:    Datapath_Raster - Behavioral 
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
use work.STD_SAD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Datapath_Raster is
   Port(	
		CLK						: in STD_LOGIC;
		START						: in STD_LOGIC;
		foundBetterSAD			: in STD_LOGIC;
		initData					: in STD_LOGIC;
		initIncrement			: in STD_LOGIC;
		rearrangeVecMems		: in STD_LOGIC;
		incRegX					: in STD_LOGIC;
		loadRegXMem2			: in STD_LOGIC;
		sendToMem				: in STD_LOGIC;
		searchRange				: in STD_LOGIC_VECTOR(7 downto 0);
		heightPU					: in STD_LOGIC_VECTOR(6 downto 0);
		widthPU					: in STD_LOGIC_VECTOR(6 downto 0);
		initCenterX				: in STD_LOGIC_VECTOR(7 downto 0);
		initCenterY				: in STD_LOGIC_VECTOR(7 downto 0);
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
end Datapath_Raster;

architecture Behavioral of Datapath_Raster is

signal middleSubResult, middleNrAccumSubSrc: STD_LOGIC;
signal currentXVecByPass1, currentXVecByPass2, currentXVecByPass3, currentXVecByPass4, currentXVecByPass5, currentXVecByPass6, currentXVecByPass7, currentXVecByPass8: STD_LOGIC_VECTOR(7 downto 0);
signal currentYVecByPass1, currentYVecByPass2, currentYVecByPass3, currentYVecByPass4, currentYVecByPass5, currentYVecByPass6, currentYVecByPass7, currentYVecByPass8: STD_LOGIC_VECTOR(7 downto 0);
signal multHW: STD_LOGIC_VECTOR(13 downto 0);
signal latency, regLatency, regSubLatency, subLatency: STD_LOGIC_VECTOR(7 downto 0);
signal auxRegBorderRight, auxRegBorderDown: STD_LOGIC_VECTOR(7 downto 0);
signal regBorderRight, regBorderLeft, regBorderDown, regBorderUp: STD_LOGIC_VECTOR(7 downto 0);
signal regBestInitialX, regBestInitialY, regSearchRange: STD_LOGIC_VECTOR(7 downto 0);
signal regBestSAD: STD_LOGIC_VECTOR(19 downto 0);
signal regBestInitialSAD: STD_LOGIC_VECTOR(19 downto 0);
signal regXMem, regYMem, regYMemAfter: STD_LOGIC_VECTOR(7 downto 0);
signal regXMem2, regYMem2: STD_LOGIC_VECTOR(7 downto 0);
signal regXMem3, regYMem3: STD_LOGIC_VECTOR(7 downto 0);
signal subRight, subDown: STD_LOGIC_VECTOR(7 downto 0);
signal auxIsOutOfXBound, auxIsOutOfYBound, regIsOutOfXBound, regIsOutOfYBound: STD_LOGIC;
signal S_SAD, regDifferenceSADs: STD_LOGIC_VECTOR(19 downto 0);
signal flagBetterSAD: STD_LOGIC;
signal doneRest, done44, done48: STD_LOGIC;
signal curRegBestVecX, curRegBestVecY: STD_LOGIC_VECTOR(7 downto 0);
signal done: STD_LOGIC;
--signal auxIs8x8or16x4: STD_LOGIC;
signal middleValidSAD: STD_LOGIC;
signal regInitCenterX, regInitCenterY: STD_LOGIC_VECTOR(7 downto 0);

begin

multHW <= heightPU * widthPU;
latency <= ('0' & multHW (12 downto 6)) - 1;

finishSendPartitions <= regSubLatency(7);

auxIsOutOfXBound <= '1' when subRight(7) = '0' else
					  '0';
auxIsOutOfYBound <= '1' when subDown(7) = '0' else
					  '0';

subRight <= regXMem - regBorderRight;
subDown <= regYMemAfter - regBorderDown;

bestVecX <= curRegBestVecX;
bestVecY <= curRegBestVecY;
xMem <= regXMem3;
yMem <= regYMem3;
isOutOfXBound <= regIsOutOfXBound;
isOutOfYBound <= regIsOutOfYBound;

	process(CLK, START)
	begin
		if(START='0') then
			regInitCenterX <= (OTHERS=>'0');
			regInitCenterY <= (OTHERS=>'0');
			regSearchRange <= (OTHERS=>'0');
			regBorderLeft <= (OTHERS=>'0');
			regBorderRight <= (OTHERS=>'0');
			regBorderUp <= (OTHERS=>'0');
			regBorderDown <= (OTHERS=>'0');
			regBestInitialX <= (OTHERS=>'0');
			regBestInitialY <= (OTHERS=>'0');
			regBestInitialSAD <= (OTHERS=>'0');
			regLatency <= (OTHERS=>'0');
			regSubLatency <= (OTHERS=>'0');
			curRegBestVecX <= (OTHERS=>'0');
			curRegBestVecY <= (OTHERS=>'0');
			regXMem <= (OTHERS=>'0');
			regYMem <= (OTHERS=>'0');
			regXMem2 <= (OTHERS=>'0');
			regYMem2 <= (OTHERS=>'0');
			regXMem3 <= (OTHERS=>'0');
			regYMem3 <= (OTHERS=>'0');
			auxRegBorderRight <= (OTHERS=>'0');
			auxRegBorderDown <= (OTHERS=>'0');
			regIsOutOfXBound <= '0';
			regIsOutOfYBound <= '0';
			regYMemAfter <= (OTHERS=>'0');
--			regXMem <= bestInitialX - searchRange;
--			regYMem <= bestInitialY - searchRange;
			
		elsif(CLK'event and CLK='1') then
			regBestInitialX <= bestInitialX;
			regBestInitialY <= bestInitialY;
			regSearchRange <= searchRange;
			regLatency <= latency;
			regBorderLeft <= initCenterX - regSearchRange;
			regBorderUp <= initCenterY - regSearchRange;
			
			
			auxRegBorderRight <= initCenterX + regSearchRange;
			auxRegBorderDown <= initCenterY + regSearchRange;
			
			regBorderRight <= auxRegBorderRight - widthPU;
			regBorderDown <= auxRegBorderDown - heightPU;
						
			regYMemAfter <= regYMem + IRASTER;
			
			if(initData = '1') then
				curRegBestVecX <= regBestInitialX;
				curRegBestVecY <= regBestInitialY;
				regXMem <= regBorderLeft; --PODE-SE USAR OUTRO SOMADOR PARA FAZER TUDO UM CICLO ANTES
				regYMem <= regBorderUp;
			end if;
			
			if(initIncrement = '1') then
				regSubLatency <= subLatency - 1;
			else
				regSubLatency <= regLatency;
			end if;
			
			if(sendToMem = '1') then
				regXMem3 <= regXMem2;
				regYMem3 <= regYMem2;
			end if;
			
			if(loadRegXMem2 = '1') then
				regXMem2 <= regXMem;
				regYMem2 <= regYMem;
				regIsOutOfXBound <= auxIsOutOfXBound;
				regIsOutOfYBound <= auxIsOutOfYBound;
			end if;

			if(incRegX = '1') then
				regXMem <= regXMem + IRASTER;
			end if;
			
			if(rearrangeVecMems = '1') then
				regXMem3 <= regBorderLeft;
				regYMem3 <= regYMem3 + IRASTER;
				regXMem2 <= regBorderLeft + IRASTER;
				regYMem2 <= regYMem3 + IRASTER;
				regXMem <= regBorderLeft + DOUBLE_IRASTER;
				regYMem <= regYMem3 + IRASTER;
				regIsOutOfXBound <= '0';
				regIsOutOfYBound <= '0';
			end if;
			
			if(foundBetterSAD = '1') then
				curRegBestVecX <= currentXVecByPass8;
				curRegBestVecY <= currentYVecByPass8;
			end if;
			
			
		end if;
	end process;

	with regSubLatency(7) select
		subLatency <= regLatency when '1',
						  regSubLatency when OTHERS;
	
	
	
	
	
	
	
	process(CLK, START)
	begin
		if(START = '0') then
			currentXVecByPass1 <= (OTHERS=>'0');
			currentXVecByPass2 <= (OTHERS=>'0');
			currentXVecByPass3 <= (OTHERS=>'0');
			currentXVecByPass4 <= (OTHERS=>'0');
			currentXVecByPass5 <= (OTHERS=>'0');
			currentXVecByPass6 <= (OTHERS=>'0');
			currentXVecByPass7 <= (OTHERS=>'0');
			currentXVecByPass8 <= (OTHERS=>'0');
			currentYVecByPass1 <= (OTHERS=>'0');
			currentYVecByPass2 <= (OTHERS=>'0');
			currentYVecByPass3 <= (OTHERS=>'0');
			currentYVecByPass4 <= (OTHERS=>'0');
			currentYVecByPass5 <= (OTHERS=>'0');
			currentYVecByPass6 <= (OTHERS=>'0');
			currentYVecByPass7 <= (OTHERS=>'0');
			currentYVecByPass8 <= (OTHERS=>'0');
		elsif(CLK'event and CLK='1') then
			currentXVecByPass1 <= regXMem;
			currentXVecByPass2 <= currentXVecByPass1;
			currentXVecByPass3 <= currentXVecByPass2;
			currentXVecByPass4 <= currentXVecByPass3;
			currentXVecByPass5 <= currentXVecByPass4;
			currentXVecByPass6 <= currentXVecByPass5;
			currentXVecByPass7 <= currentXVecByPass6;
			currentXVecByPass8 <= currentXVecByPass7;
			currentYVecByPass1 <= regYMem;
			currentYVecByPass2 <= currentYVecByPass1;
			currentYVecByPass3 <= currentYVecByPass2;
			currentYVecByPass4 <= currentYVecByPass3;
			currentYVecByPass5 <= currentYVecByPass4;
			currentYVecByPass6 <= currentYVecByPass5;
			currentYVecByPass7 <= currentYVecByPass6;
			currentYVecByPass8 <= currentYVecByPass7;
		end if;
	end process;

end Behavioral;

