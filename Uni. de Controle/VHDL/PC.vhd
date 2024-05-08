library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port( 
        clk      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
 end entity;

 architecture a_PC of PC is
    signal soma: unsigned(15 downto 0);
 begin
    process(clk, wr_en)  -- acionado se houver mudança em clk ou wr_en
    begin                
       if wr_en='1' then
           if rising_edge(clk) then
             data_out <= data_in;
          end if;
       end if;
    end process;
    
    data_out <= soma;  -- conexao direta, fora do processo
 end architecture;