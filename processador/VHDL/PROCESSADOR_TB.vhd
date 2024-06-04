library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PROCESSADOR_TB is
    port(

        constante_entrada_pc : out unsigned(6 downto 0) := "0000000";
        endereco_saida_pc : out unsigned(6 downto 0) := "0000000";
        

        somar : out std_logic := '0';
        saltar : out std_logic := '0';

        ula_ina : out unsigned(15 downto 0) := "0000000000000000";
        ula_inb : out unsigned(15 downto 0) := "0000000000000000";
        result : out unsigned(15 downto 0) := "0000000000000000";

        jbit5 : out std_logic := '0';
        jump : out std_logic := '0';
        branch : out std_logic := '0';

        instrucao_erro : out unsigned(3 downto 0) := "0000";
        brake_erro : out std_logic := '0';
        fet_erro_endereco : out std_logic := '0'
    );
end entity;





architecture A_PROCESSADOR_TB of PROCESSADOR_TB is 
    signal contador : unsigned(8 downto 0) := "000000000";

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal estado : unsigned(1 downto 0) := "00";

    component PROCESSADOR is
        port(
            clk : in std_logic;
            rst : in std_logic;
            estado : in unsigned(1 downto 0);
            constante_entrada_pc : out unsigned(6 downto 0);
            endereco_saida_pc : out unsigned(6 downto 0);
            somar : out std_logic;
            saltar : out std_logic;
            ula_ina : out unsigned(15 downto 0);
            ula_inb : out unsigned(15 downto 0);
            result : out unsigned(15 downto 0);
            jbit5 : out std_logic;
            jump : out std_logic;
            branch : out std_logic;
            instrucao_erro : out unsigned(3 downto 0);
            brake_erro : out std_logic;
            fet_erro_endereco : out std_logic
        );
    end component;

    begin 
        UUT : PROCESSADOR port map(
            clk => clk,
            rst => rst,
            estado => estado,
            constante_entrada_pc => constante_entrada_pc,
            endereco_saida_pc => endereco_saida_pc,
            somar => somar,
            saltar => saltar,
            ula_ina => ula_ina,
            ula_inb => ula_inb,
            result => result,
            jbit5 => jbit5,
            jump => jump,
            branch => branch,
            instrucao_erro => instrucao_erro,
            brake_erro => brake_erro,
            fet_erro_endereco => fet_erro_endereco
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
            while contador /= "111111111" loop
                
                clk <= '0';
                wait for 50 ns;
                clk <= '1';
                contador <= contador + 1;
                wait for 50 ns;

                if estado = "10" then 
                    estado <= "00";
                else
                    estado <= estado + 1;
                end if;
            end loop;
            wait;
    end process;


end architecture;