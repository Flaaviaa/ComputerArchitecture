LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity ram_tb is
    end;

    architecture a_ram_tb of ram_tb is 
 
    COMPONENT ram is
        PORT(
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            dado_in  : in unsigned(15 downto 0);
            dado_out : out unsigned(15 downto 0)
        );
    END COMPONENT;
    
   signal endereco : unsigned(6 downto 0);
   signal dado_in : unsigned(15 downto 0);
   signal wr_en, reset : std_logic;
   signal clk : std_logic := '0';
   signal dado_out : unsigned(15 downto 0) := B"0000_0000_0000_0000";
   constant period_time : time      := 100 ns;
   signal   finished    : std_logic := '0';

   constant period : time := 10 ns;
 
BEGIN
   uut: ram PORT MAP (
          endereco => endereco,
          dado_in => dado_in,
          wr_en => wr_en,
          clk => clk,
          dado_out => dado_out
        );

        reset_global: process
        begin
            reset <= '1';
            wait for period_time*2; -- espera 2 clocks, pra garantir
            reset <= '0';
            wait;
        end process;
        
        sim_time_proc: process
        begin
            wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
            finished <= '1';
            wait;
        end process sim_time_proc;
        clk_proc: process
        begin                       -- gera clock até que sim_time_proc termine
            while finished /= '1' loop
                clk <= '0';
                wait for period_time/2;
                clk <= '1';
                wait for period_time/2;
            end loop;
            wait;
        end process clk_proc;

   stim_proc: process
  begin  
    wr_en <= '0'; 
    endereco <= "0000000";
    dado_in <= "0000001011100011";
    wait for 100 ns;
    dado_in <= "0000001011100011";
    endereco <= "0000000";
    wr_en <= '1';
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0000010";
    dado_in <= "0000001010100011";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0000011";
    dado_in <= "0000001010100111";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0000001";
    dado_in <= "0000001110100011";
    wait for period*5; 
    wr_en <= '1'; 
    endereco <= "0000100";
    dado_in <= "0000111010100111";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0000101";
    dado_in <= "0000001010111011";
    wait for period*5; 
    wr_en <= '1'; 
    endereco <= "0000110";
    dado_in <= "0000001010100001";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0000111";
    dado_in <= "0110001110100011";
    wait for period*5; 
    wr_en <= '1'; 
    endereco <= "0001000";
    dado_in <= "0000000010100111";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0001001";
    dado_in <= "0000001010111000";
    wait for period*5; 
    wr_en <= '1'; 
    endereco <= "0001010";
    dado_in <= "0000001010111101";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0001011";
    dado_in <= "0110000000000011";
    wait for period*5; 
    wr_en <= '1'; 
    endereco <= "0001100";
    dado_in <= "0000111010100111";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0001101";
    dado_in <= "0000001010111011";
    wait for period*5; 
    wr_en <= '1'; 
    endereco <= "0001110";
    dado_in <= "0000001010100001";
    wait for period*5;
    wr_en <= '1'; 
    endereco <= "0001111";
    dado_in <= "0110001110100011";
    wait for 100 ns;
    wr_en <= '0'; 
    endereco <= "0000010";
    wait for period*5; 
    wr_en <= '0'; 
    endereco <= "0000011";
    dado_in <= "0000001010100111";
    wait for period*5;
    wr_en <= '0'; 
    endereco <= "0000001";
    wait for period*5; 
    wr_en <= '0'; 
    endereco <= "0000100";
    wait for period*5;
    wr_en <= '0'; 
    endereco <= "0000101";
    wait for period*5; 
    wr_en <= '0'; 
    endereco <= "0000110";
    wait for period*5;
    wr_en <= '0'; 
    endereco <= "0000111";
    wait for period*5; 
    wr_en <= '0'; 
    endereco <= "0001000";
    wait for period*5;
    wr_en <= '0'; 
    endereco <= "0001001";
    wait for period*5; 
    wr_en <= '0'; 
    endereco <= "0001010";
    wait for period*5;
    wr_en <= '0'; 
    endereco <= "0001011";
    wait for period*5; 
    wr_en <= '0'; 
    endereco <= "0001100";
    wait for period*5;
    wr_en <= '0'; 
    endereco <= "0001101";
    wait for period*5; 
    wr_en <= '0'; 
    endereco <= "0001110";
    wait for period*5;
    wr_en <= '0'; 
    endereco <= "0001111";
    wait;
   end process;
END;
