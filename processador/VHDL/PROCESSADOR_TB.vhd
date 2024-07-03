library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PROCESSADOR_TB is
    port(
        instrucao_erro : out unsigned(3 downto 0) := "0000";
        brake : out std_logic := '0';
        fet_erro_endereco : out std_logic := '0'
    );
end entity;





architecture A_PROCESSADOR_TB of PROCESSADOR_TB is 
    signal contador : unsigned(13 downto 0) := "00000000000000";

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal estado : unsigned(1 downto 0) := "00";
    signal erro_ram : std_logic := '0';

    component PROCESSADOR is
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            instrucao_erro : out unsigned(3 downto 0);
            brake : out std_logic;
            fet_erro_endereco : out std_logic;
            erro_ram : out std_logic
        );
    end component;

    begin 
        UUT : PROCESSADOR port map(
            clk => clk,
            rst => rst,
            estado => estado,
            instrucao_erro => instrucao_erro,
            brake => brake,
            fet_erro_endereco => fet_erro_endereco,
            erro_ram => erro_ram
        );

    reset : process
        begin 
            rst <= '1';
            wait for 50 ns;
            rst <= '0';
            wait;
    end process reset;

    process
        begin 
            while contador /= "11111111111111" loop
                
                clk <= '0';
                wait for 50 ns;
                clk <= '1';
                wait for 50 ns;
                if estado = "10" then 
                    estado <= "00";
                else
                    estado <= estado + 1;
                end if;
                contador <= contador + 1;
            end loop;
            wait;
    end process;


end architecture;