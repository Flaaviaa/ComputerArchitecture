LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
 
ARCHITECTURE a_ram_tb OF ram_tb IS 
 
    COMPONENT ram
    PORT(
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        wr_en    : in std_logic;
        dado_in  : in unsigned(15 downto 0);
        dado_out : out unsigned(15 downto 0)
        );
    END COMPONENT;
    
   signal endereco : std_logic_vector(6 downto 0) := (others => '0');
   signal dado_in : std_logic_vector(7 downto 0) := (others => '0');
   signal wr_en : std_logic := '0';
   signal clk : std_logic := '0';
   signal dado_out : std_logic_vector(7 downto 0);

   constant period : time := 10 ns;
 
BEGIN
   uut: ram PORT MAP (
          endereco => endereco,
          dado_in => dado_in,
          wr_en => wr_en,
          clk => clk,
          dado_out => dado_out
        );

   clk_process :process
   begin
   clk <= '0';
   wait for period/2;
   clk <= '1';
   wait for period/2;
   end process;

   stim_proc: process
   begin  
  wr_en <= '0'; 
  endereco <= "0000000";
  dado_in <= x"FF";
      wait for 100 ns; 
  for i in 0 to 5 loop
  endereco <= endereco + "0000001";
      wait for period*5;
  end loop;
  endereco <= "0000000";
  wr_en <= '1';
  wait for 100 ns; 
  for i in 0 to 5 loop
  endereco <= endereco + "0000001";
  dado_in <= dado_in-x"01";
      wait for clk_period*5;
  end loop;  
  wr_en <= '0';
      wait;
   end process;

END;