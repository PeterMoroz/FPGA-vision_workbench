-- sharp_h_matrix.vhd
--
-- arithmetic for 3x3 matrix of sharpening filter

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sharp_h_matrix is
  port ( clk       : in  std_logic;
         reset     : in  std_logic;
	
         t_00      : in  std_logic_vector(23 downto 0);
         t_01      : in  std_logic_vector(23 downto 0);
         t_02      : in  std_logic_vector(23 downto 0);
         t_10      : in  std_logic_vector(23 downto 0);
         t_11      : in  std_logic_vector(23 downto 0);
         t_12      : in  std_logic_vector(23 downto 0);
         t_20      : in  std_logic_vector(23 downto 0);
         t_21      : in  std_logic_vector(23 downto 0);
         t_22      : in  std_logic_vector(23 downto 0);
			
         data_out  : out std_logic_vector(23 downto 0));
end sharp_h_matrix;

architecture behave of sharp_h_matrix is
	
	signal r00, r01, r02, r10, r11, r12, r20, r21, r22 : integer range 0 to 255;
	signal g00, g01, g02, g10, g11, g12, g20, g21, g22 : integer range 0 to 255;
	signal b00, b01, b02, b10, b11, b12, b20, b21, b22 : integer range 0 to 255;
	
	signal r, g, b : integer range 0 to 255;

begin

process
	variable rsum, gsum, bsum : integer range -2040 to 2295;	
begin
   wait until rising_edge(clk);
	
	r00 <= to_integer(unsigned(t_00(23 downto 16)));
	g00 <= to_integer(unsigned(t_00(15 downto 8)));
	b00 <= to_integer(unsigned(t_00(7 downto 0)));
	
	r01 <= to_integer(unsigned(t_01(23 downto 16)));
	g01 <= to_integer(unsigned(t_01(15 downto 8)));
	b01 <= to_integer(unsigned(t_01(7 downto 0)));
	
	r02 <= to_integer(unsigned(t_02(23 downto 16)));
	g02 <= to_integer(unsigned(t_02(15 downto 8)));
	b02 <= to_integer(unsigned(t_02(7 downto 0)));
	
	r10 <= to_integer(unsigned(t_10(23 downto 16)));
	g10 <= to_integer(unsigned(t_10(15 downto 8)));
	b10 <= to_integer(unsigned(t_10(7 downto 0)));

	r11 <= to_integer(unsigned(t_11(23 downto 16)));
	g11 <= to_integer(unsigned(t_11(15 downto 8)));
	b11 <= to_integer(unsigned(t_11(7 downto 0)));

	r12 <= to_integer(unsigned(t_12(23 downto 16)));
	g12 <= to_integer(unsigned(t_12(15 downto 8)));
	b12 <= to_integer(unsigned(t_12(7 downto 0)));
	
	r20 <= to_integer(unsigned(t_20(23 downto 16)));
	g20 <= to_integer(unsigned(t_20(15 downto 8)));
	b20 <= to_integer(unsigned(t_20(7 downto 0)));
	
	r21 <= to_integer(unsigned(t_21(23 downto 16)));
	g21 <= to_integer(unsigned(t_21(15 downto 8)));
	b21 <= to_integer(unsigned(t_21(7 downto 0)));

	r22 <= to_integer(unsigned(t_22(23 downto 16)));
	g22 <= to_integer(unsigned(t_22(15 downto 8)));
	b22 <= to_integer(unsigned(t_22(7 downto 0)));
		

	rsum := -1*r00 -1*r01 -1*r02 -1*r10 +9*r11 -1*r12 -1*r20 -1*r21 -1*r22;
	gsum := -1*g00 -1*g01 -1*g02 -1*g10 +9*g11 -1*g12 -1*g20 -1*g21 -1*g22;
	bsum := -1*b00 -1*b01 -1*b02 -1*b10 +9*b11 -1*b12 -1*b20 -1*b21 -1*b22;
	
	if (rsum < 0) then
		r <= 0;
	elsif (rsum > 255) then
		r <= 255;
	else
		r <= rsum;
	end if;
	
	if (gsum < 0) then
		g <= 0;
	elsif (gsum > 255) then
		g <= 255;
	else
		g <= gsum;
	end if;

	if (bsum < 0) then
		b <= 0;
	elsif (bsum > 255) then
		b <= 255;
	else
		b <= bsum;
	end if;
	
	
   data_out <= std_logic_vector(to_unsigned(r, 8)) & std_logic_vector(to_unsigned(g, 8)) & std_logic_vector(to_unsigned(b, 8));
end process;

end behave;
