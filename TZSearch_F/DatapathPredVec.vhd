----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:20:38 06/10/2015 
-- Design Name: 
-- Module Name:    DatapathPredVec - Behavioral 
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

entity DatapathPredVec is
	Port(
		CLK				: in STD_LOGIC;
		START				: in STD_LOGIC;
		vecX				: in STD_LOGIC_VECTOR(7 downto 0);
		vecY				: in STD_LOGIC_VECTOR(7 downto 0);
		bestVecX			: out STD_LOGIC_VECTOR(7 downto 0);
		bestVecY			: out STD_LOGIC_VECTOR(7 downto 0)
	);
end DatapathPredVec;

architecture Behavioral of DatapathPredVec is

signal inVecXByPass1, inVecXByPass2, inVecXByPass3, inVecXByPass4, inVecXByPass5, inVecXByPass6, inVecXByPass7, inVecXByPass8, inVecXByPass9: STD_LOGIC_VECTOR(7 downto 0);
signal inVecYByPass1, inVecYByPass2, inVecYByPass3, inVecYByPass4, inVecYByPass5, inVecYByPass6, inVecYByPass7, inVecYByPass8, inVecYByPass9: STD_LOGIC_VECTOR(7 downto 0);

begin

bestVecX <= inVecXByPass9;
bestVecY <= inVecYByPass9;

process(START, CLK)
begin
	if(START='0') then
	
		---------------------------------
		inVecXByPass1 <= (OTHERS=>'0');
		inVecXByPass2 <= (OTHERS=>'0');
		inVecXByPass3 <= (OTHERS=>'0');
		inVecXByPass4 <= (OTHERS=>'0');
		inVecXByPass5 <= (OTHERS=>'0');
		inVecXByPass6 <= (OTHERS=>'0');
		inVecXByPass7 <= (OTHERS=>'0');
		inVecXByPass8 <= (OTHERS=>'0');
		inVecXByPass9 <= (OTHERS=>'0');
		inVecYByPass1 <= (OTHERS=>'0');
		inVecYByPass2 <= (OTHERS=>'0');
		inVecYByPass3 <= (OTHERS=>'0');
		inVecYByPass4 <= (OTHERS=>'0');
		inVecYByPass5 <= (OTHERS=>'0');
		inVecYByPass6 <= (OTHERS=>'0');
		inVecYByPass7 <= (OTHERS=>'0');
		inVecYByPass8 <= (OTHERS=>'0');
		inVecYByPass9 <= (OTHERS=>'0');
		---------------------------------
		---------------------------------
	
		regBestVecX <= (OTHERS=>'0');
		regBestVecY <= (OTHERS=>'0');
		
	elsif(CLK'event and CLK='1') then
	
		-----------------------------------
		inVecXByPass1 <= vecX;
		inVecXByPass2 <= inVecXByPass1;
		inVecXByPass3 <= inVecXByPass2;
		inVecXByPass4 <= inVecXByPass3;
		inVecXByPass5 <= inVecXByPass4;
		inVecXByPass6 <= inVecXByPass5;
		inVecXByPass7 <= inVecXByPass6;
		inVecXByPass8 <= inVecXByPass7;
		inVecXByPass9 <= inVecXByPass8;
		inVecYByPass1 <= vecY;
		inVecYByPass2 <= inVecYByPass1;
		inVecYByPass3 <= inVecYByPass2;
		inVecYByPass4 <= inVecYByPass3;
		inVecYByPass5 <= inVecYByPass4;
		inVecYByPass6 <= inVecYByPass5;
		inVecYByPass7 <= inVecYByPass6;
		inVecYByPass8 <= inVecYByPass7;
		inVecYByPass9 <= inVecYByPass8;
		-----------------------------------
		-----------------------------------

	end if;
end process;

end Behavioral;

