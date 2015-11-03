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
end Datapath_Raster;

architecture Behavioral of Datapath_Raster is

signal currentXVecByPass1, currentXVecByPass2, currentXVecByPass3, currentXVecByPass4, currentXVecByPass5, currentXVecByPass6, currentXVecByPass7, currentXVecByPass8, currentXVecByPass9, currentXVecByPass10: STD_LOGIC_VECTOR(7 downto 0);
signal currentYVecByPass1, currentYVecByPass2, currentYVecByPass3, currentYVecByPass4, currentYVecByPass5, currentYVecByPass6, currentYVecByPass7, currentYVecByPass8, currentYVecByPass9, currentYVecByPass10: STD_LOGIC_VECTOR(7 downto 0);
signal regLatency, regSubLatency, subLatency: STD_LOGIC_VECTOR(7 downto 0);
signal regBestInitialX, regBestInitialY: STD_LOGIC_VECTOR(7 downto 0);
signal regXMem, regYMem, regYMemAfter: STD_LOGIC_VECTOR(7 downto 0);
signal regXMem2, regYMem2: STD_LOGIC_VECTOR(7 downto 0);
signal regXMem3, regYMem3: STD_LOGIC_VECTOR(7 downto 0);
signal subRight, subDown: STD_LOGIC_VECTOR(7 downto 0);
signal auxIsOutOfXBound, auxIsOutOfYBound, regIsOutOfXBound, regIsOutOfYBound: STD_LOGIC;
--signal curRegBestVecX, curRegBestVecY: STD_LOGIC_VECTOR(7 downto 0);
--signal regInitCenterX, regInitCenterY: STD_LOGIC_VECTOR(7 downto 0);

begin

finishSendPartitions <= regSubLatency(7);

auxIsOutOfXBound <= '1' when subRight(7) = '0' else
					  '0';
auxIsOutOfYBound <= '1' when subDown(7) = '0' else
					  '0';

subRight <= regXMem - borderRight;
subDown <= regYMemAfter - borderDown;

--bestVecX <= curRegBestVecX;
--bestVecY <= curRegBestVecY;
bestVecX <= currentXVecByPass9;
bestVecY <= currentYVecByPass9;
xMem <= regXMem3;
yMem <= regYMem3;
isOutOfXBound <= regIsOutOfXBound;
isOutOfYBound <= regIsOutOfYBound;

	process(CLK, START)
	begin
		if(START='0') then
--			regInitCenterX <= (OTHERS=>'0');
--			regInitCenterY <= (OTHERS=>'0');
			regBestInitialX <= (OTHERS=>'0');
			regBestInitialY <= (OTHERS=>'0');
			regLatency <= (OTHERS=>'0');
			regSubLatency <= (OTHERS=>'0');
--			curRegBestVecX <= (OTHERS=>'0');
--			curRegBestVecY <= (OTHERS=>'0');
			regXMem <= (OTHERS=>'0');
			regYMem <= (OTHERS=>'0');
			regXMem2 <= (OTHERS=>'0');
			regYMem2 <= (OTHERS=>'0');
			regXMem3 <= (OTHERS=>'0');
			regYMem3 <= (OTHERS=>'0');
			regIsOutOfXBound <= '0';
			regIsOutOfYBound <= '0';
			regYMemAfter <= (OTHERS=>'0');
--			regXMem <= bestInitialX - searchRange;
--			regYMem <= bestInitialY - searchRange;
			
		elsif(CLK'event and CLK='1') then
			regBestInitialX <= bestInitialX;
			regBestInitialY <= bestInitialY;
			regLatency <= cyclesPerPU;
						
			regYMemAfter <= regYMem + IRASTER;
			
			if(initData = '1') then
--				curRegBestVecX <= regBestInitialX;
--				curRegBestVecY <= regBestInitialY;
				regXMem <= borderLeft; --PODE-SE USAR OUTRO SOMADOR PARA FAZER TUDO UM CICLO ANTES
				regYMem <= borderUp;
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
				regXMem3 <= borderLeft;
				regYMem3 <= regYMem3 + IRASTER;
				regXMem2 <= borderLeft + IRASTER;
				regYMem2 <= regYMem3 + IRASTER;
				regXMem <= borderLeft + DOUBLE_IRASTER;
				regYMem <= regYMem3 + IRASTER;
				regIsOutOfXBound <= '0';
				regIsOutOfYBound <= '0';
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
			currentXVecByPass1 <= regXMem3;
			currentXVecByPass2 <= currentXVecByPass1;
			currentXVecByPass3 <= currentXVecByPass2;
			currentXVecByPass4 <= currentXVecByPass3;
			currentXVecByPass5 <= currentXVecByPass4;
			currentXVecByPass6 <= currentXVecByPass5;
			currentXVecByPass7 <= currentXVecByPass6;
			currentXVecByPass8 <= currentXVecByPass7;
			currentXVecByPass9 <= currentXVecByPass8;
			currentXVecByPass10 <= currentXVecByPass9;
			currentYVecByPass1 <= regYMem3;
			currentYVecByPass2 <= currentYVecByPass1;
			currentYVecByPass3 <= currentYVecByPass2;
			currentYVecByPass4 <= currentYVecByPass3;
			currentYVecByPass5 <= currentYVecByPass4;
			currentYVecByPass6 <= currentYVecByPass5;
			currentYVecByPass7 <= currentYVecByPass6;
			currentYVecByPass8 <= currentYVecByPass7;
			currentYVecByPass9 <= currentYVecByPass8;
			currentYVecByPass10 <= currentYVecByPass9;
		end if;
	end process;

end Behavioral;

