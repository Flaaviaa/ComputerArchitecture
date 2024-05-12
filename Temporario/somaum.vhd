library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somaum is
    port (
        clk : in std_logic;
        entrada : in unsigned(6 downto 0);
        saida   : out unsigned(6 downto 0)
    );
end entity;

architecture a_somaum of somaum is
    begin
        process(clk)  -- acionado se houver mudança em clk ou wr_en
        begin                
            if falling_edge(clk) then
                saida <= entrada + "0000001";
            end if;
        end process;

end architecture;
	