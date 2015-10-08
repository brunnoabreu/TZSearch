----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:06 12/04/2014 
-- Design Name: 
-- Module Name:    Datapath - Behavioral 
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
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;
use work.STD_SAD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Datapath is
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
		heightPU				: in STD_LOGIC_VECTOR(6 downto 0);
		widthPU				: in STD_LOGIC_VECTOR(6 downto 0);
		nrAccumSubSrc		: in STD_LOGIC;
		validSAD				: in STD_LOGIC;
		subResult			: out STD_LOGIC;
		SAD441				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD442				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD443				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD444				: out STD_LOGIC_VECTOR(11 downto 0);
		SAD481				: out STD_LOGIC_VECTOR(12 downto 0);
		SAD482				: out STD_LOGIC_VECTOR(12 downto 0);
		SAD        			: out STD_LOGIC_VECTOR(19 downto 0)
	);
end Datapath;

architecture Behavioral of Datapath is

type t_mat is array(0 to 3) of matrixSAD; --Apenas para juntar as 8 matrizes em duas variáveis com índices.
type t_firstAfterBlock is array(0 to 3) of STD_LOGIC_VECTOR(11 downto 0);
type t_secAfterBlock is array(0 to 1) of STD_LOGIC_VECTOR(12 downto 0);

signal matsA, matsB: t_mat;
signal firstAfterBlock, regByPass441, regByPass442, regByPass44: t_firstAfterBlock;
signal regSecAfterBlock, secAfterBlock, regByPass481, regByPass48: t_secAfterBlock;
signal outSum, outAfterSum: STD_LOGIC_VECTOR(13 downto 0);
signal S_SAD, regSAD: STD_LOGIC_VECTOR(19 downto 0);
signal nrAccum, regNrAccum: STD_LOGIC_VECTOR(7 downto 0);
signal subSrc, regSubSrc: STD_LOGIC_VECTOR(7 downto 0);
signal multHW: STD_LOGIC_VECTOR(13 downto 0);

----------- NEW ----------------
--signal heightPUByPass1, heightPUByPass2, heightPUByPass3, heightPUByPass4, heightPUByPass5, heightPUByPass6, heightPUByPass7, heightPUByPass8: STD_LOGIC_VECTOR(6 downto 0);
--signal widthPUByPass1, widthPUByPass2, widthPUByPass3, widthPUByPass4, widthPUByPass5, widthPUByPass6, widthPUByPass7, widthPUByPass8: STD_LOGIC_VECTOR(6 downto 0);
--------------------------------


component blck4x4 is
	Port(
		matA : in matrixSAD;
		matB : in matrixSAD;
		clk, start  : in std_logic;
		S    : out std_logic_vector(8 + log2_total - 1 downto 0	));
end component;

component genericAdder is
	generic(
		widthX : integer
	);
	port(
			a: in std_logic_vector(widthX-1 downto 0);
			b: in std_logic_vector(widthX-1 downto 0);
			c: out std_logic_vector(widthX downto 0)
	);
end component;

begin	

subResult <= regSubSrc(7);
multHW <= heightPU * widthPU;
nrAccum <= ('0' & multHW (12 downto 6)) - 1;
SAD <= S_SAD;

defInReg: process(CLK,START)
begin
	if(START='0') then
		matsA 			  <= (OTHERS=>(OTHERS=>(OTHERS=>(OTHERS=>'0'))));
		matsB 			  <= (OTHERS=>(OTHERS=>(OTHERS=>(OTHERS=>'0'))));
		regSecAfterBlock <= (OTHERS=>(OTHERS=>'0'));
		S_SAD 			  <= (OTHERS=>'0');
		outAfterSum 	  <= (OTHERS=>'0');
		regByPass441 	  <= (OTHERS=>(OTHERS=>'0'));
		regByPass442 	  <= (OTHERS=>(OTHERS=>'0'));
		regByPass44 	  <= (OTHERS=>(OTHERS=>'0'));
		regByPass481 	  <= (OTHERS=>(OTHERS=>'0'));
		regByPass48 	  <= (OTHERS=>(OTHERS=>'0'));
		regSubSrc 		  <= (OTHERS=>'0');
		regNrAccum 		  <= (OTHERS=>'0');
--		multHW 			  <= (OTHERS=>'0');
--		------------------ NEW -------------------
--		heightPUByPass1 <= (OTHERS=>'0');
--		heightPUByPass2 <= (OTHERS=>'0');
--		heightPUByPass3 <= (OTHERS=>'0');
--		heightPUByPass4 <= (OTHERS=>'0');
--		heightPUByPass5 <= (OTHERS=>'0');
--		heightPUByPass6 <= (OTHERS=>'0');
--		heightPUByPass7 <= (OTHERS=>'0');
--		heightPUByPass8 <= (OTHERS=>'0');
--		widthPUByPass1 <= (OTHERS=>'0');
--		widthPUByPass2 <= (OTHERS=>'0');
--		widthPUByPass3 <= (OTHERS=>'0');
--		widthPUByPass4 <= (OTHERS=>'0');
--		widthPUByPass5 <= (OTHERS=>'0');
--		widthPUByPass6 <= (OTHERS=>'0');
--		widthPUByPass7 <= (OTHERS=>'0');
--		widthPUByPass8 <= (OTHERS=>'0');
--		------------------------------------------
		
		
	elsif(CLK'event and CLK='1') then
--		multHW <= heightPU * widthPU;
		if(regSubSrc(7) = '0' and validSAD = '1') then
			S_SAD <= S_SAD + ("000000" & outAfterSum); --Há mais esse nível depois do somador do fim da árvore
		else
			S_SAD <= ("000000" & outAfterSum);
		end if;		regNrAccum <= nrAccum;
		regSubSrc <= subSrc - 1;
		outAfterSum <= outSum;
		for i in 0 to 1 loop
			regSecAfterBlock(i) <= secAfterBlock(i); --Registrador depois do primeiro somador, localizado após a saída do bloco 4x4
		end loop;
		for i in 0 to 3 loop
			regByPass441(i) <= firstAfterBlock(i);
			regByPass442(i) <= regByPass441(i);
			regByPass44(i) <= regByPass442(i);
		end loop;
		for i in 0 to 1 loop
			regByPass481(i) <= regSecAfterBlock(i);
			regByPass48(i) <= regByPass481(i);
		end loop;
		matsA(0) <= matA1;
		matsB(0) <= matB1;
		matsA(1) <= matA2;
		matsB(1) <= matB2;
		matsA(2) <= matA3;
		matsB(2) <= matB3;
		matsA(3) <= matA4;
		matsB(3) <= matB4;
		
--		------------ NEW --------------
--		heightPUByPass1 <= heightPU;
--		heightPUByPass2 <= heightPUByPass1;
--		heightPUByPass3 <= heightPUByPass2;
--		heightPUByPass4 <= heightPUByPass3;
--		heightPUByPass5 <= heightPUByPass4;
--		heightPUByPass6 <= heightPUByPass5;
--		heightPUByPass7 <= heightPUByPass6;
--		heightPUByPass8 <= heightPUByPass7;
--		
--		widthPUByPass1 <= widthPU;
--		widthPUByPass2 <= widthPUByPass1;
--		widthPUByPass3 <= widthPUByPass2;
--		widthPUByPass4 <= widthPUByPass3;
--		widthPUByPass5 <= widthPUByPass4;
--		widthPUByPass6 <= widthPUByPass5;
--		widthPUByPass7 <= widthPUByPass6;
--		widthPUByPass8 <= widthPUByPass7;
--		------------------------------

	end if;
end process;

with nrAccumSubSrc select
	subSrc <= regNrAccum when '0',
				 regSubSrc when OTHERS;

-----------------------------------------------------
	SAD441 <= regByPass44(0);
	SAD442 <= regByPass44(1);
	SAD443 <= regByPass44(2);
	SAD444 <= regByPass44(3);
	SAD481 <= regByPass48(0);
	SAD482 <= regByPass48(1);

	
	gen0: for i in 0 to 3 generate
		blckX: blck4x4
			Port map(matsA(i), matsB(i), CLK, START, firstAfterBlock(i)); --Instancia os 4 blocos 4x4
	end generate gen0;

	gen1: for i in 0 to 1 generate
		addX: genericAdder --Somador pós-bloco 4x4 (liga dois deles)
			Generic Map(WIDTHX => 12) Port map(firstAfterBlock(i*2), firstAfterBlock(i*2+1), secAfterBlock(i));
	end generate gen1;
	
	add2: genericAdder --Somador final da árvore
		Generic Map(WIDTHX => 13) Port map(regSecAfterBlock(0), regSecAfterBlock(1), outSum);

end Behavioral;