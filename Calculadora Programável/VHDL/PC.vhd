library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- se wr_en =1 então 

entity PC is
    port( 
         rst      : in std_logic := '0';
         clk      : in std_logic := '0';
         wr_en    : in std_logic := '0';
         saltar  : in std_logic := '0';
         somar : in std_logic := '0';
         endereco_entrada  : in unsigned(6 downto 0) := "0000000";
         endereco_saida : out unsigned(6 downto 0) := "0000000";
         erro_endereco : out std_logic := '0'
    );
 end entity;

 architecture a_PC of PC is
   signal prox_registrador : unsigned(6 downto 0) := "0000000";
   signal atual_registrador : unsigned(6 downto 0) := "0000000";
   

   begin
      prox_registrador <= atual_registrador + 1;
      process(clk, wr_en,rst)  -- acionado se houver mudança em clk ou wr_en
      begin                
         if wr_en='1' then
               if rising_edge(clk) then
                  if saltar = '1' then
                     endereco_saida <= endereco_entrada;
                     atual_registrador <= endereco_entrada;
                  elsif somar = '1' then
                     endereco_saida <= prox_registrador - 1 + endereco_entrada;
                  else
                     endereco_saida <= prox_registrador;
                     atual_registrador <= prox_registrador;
                  end if;

               end if;
         end if;
         if rst= '1' then
            endereco_saida <= "0000000";
         end if;

      end process;
 end architecture;