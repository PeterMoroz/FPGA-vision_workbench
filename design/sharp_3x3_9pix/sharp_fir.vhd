-- sharp_fir.vhd
--
-- image sharpening algorithm
-- storage of 3x3 image region and calculation with FIR filter


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity sharp_fir is
  port (clk      : in  std_logic;
        reset    : in  std_logic;
        de_in    : in  std_logic;
        data_in  : in  std_logic_vector(23 downto 0);
        data_out : out std_logic_vector(23 downto 0));
end sharp_fir;

architecture behave of sharp_fir is

  signal tap_00, tap_01, tap_02,
			tap_10, tap_11, tap_12,
			tap_20, tap_21, tap_22 : std_logic_vector(23 downto 0);
			
  signal pix : std_logic_vector(23 downto 0);

begin

  -- current input pixel is right-bottom (22)
  tap_22 <= data_in;

  -- two line memories:   
  mem_0 : entity work.sharp_linemem
    port map (clk      => clk,
              reset    => reset,
              write_en => de_in,
              data_in  => tap_22,
              data_out => tap_12);
  mem_1 : entity work.sharp_linemem
    port map (clk      => clk,
              reset    => reset,
              write_en => de_in,
              data_in  => tap_12,
              data_out => tap_02);

  process
  begin
    wait until rising_edge(clk);
    -- delay each line by two clock cycles:
    --    shift left each pixel
	 tap_01 <= tap_02;
	 tap_00 <= tap_01;
	 tap_11 <= tap_12;
	 tap_10 <= tap_11;
	 tap_21 <= tap_22;
	 tap_20 <= tap_21;
	 
  end process;

  h : entity work.sharp_h_matrix
    port map (clk      => clk,
              reset    => reset,
              t_00     => tap_00,
			  t_01     => tap_01,
			  t_02     => tap_02,
              t_10     => tap_10,
			  t_11     => tap_11,
			  t_12     => tap_12,
              t_20     => tap_20,
			  t_21     => tap_21,
			  t_22     => tap_22,
              data_out => pix);

  data_out <= pix;

end behave;
