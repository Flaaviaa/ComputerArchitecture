library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_de_estados is
    port( clk      : in std_logic := '0';
          rst      : in std_logic := '0';
          wr_en    : in std_logic := '0';
          saida    : out unsigned(1 downto 0) := "00"
    );
 end entity;

 architecture a_maquina_de_estados of maquina_de_estados is
    signal estado: unsigned(1 downto 0) := "00";
 begin
    process(clk,rst,wr_en)  -- acionado se houver mudança em clk, rst ou wr_en
    begin                
       if rst='1' then
          estado <= "00";
       elsif wr_en='1' then
          if rising_edge(clk) then
            if estado = "10"then
               estado <= "00";
            else
               estado <= estado + 1;
            end if;
          end if;
       end if;
    end process;
    
    saida <= estado;  -- conexao direta, fora do processo
 end architecture;