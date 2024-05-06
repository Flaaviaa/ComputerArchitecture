library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testescomparacao_ULA_tb is
    end;

    architecture a_testescomparacao_ULA_tb of testescomparacao_ULA_tb is
        component ULA
        port(   ina : in unsigned(15 downto 0);
                inb : in unsigned(15 downto 0);
                operationselect : in unsigned(1 downto 0);
                carry : out std_logic;
                overflow : out std_logic;
                biggest : out std_logic;
                equal : out std_logic;
                result : out unsigned(15 downto 0)
        );
        end component;

        signal ina,inb,result : unsigned(15 downto 0);
        signal operationselect : unsigned(1 downto 0);
        signal carry,overflow,biggest,equal : std_logic;

        begin 
            uut : ULA port map(
                ina => ina,
                inb => inb,
                operationselect => operationselect,
                carry => carry,
                overflow => overflow,
                biggest => biggest,
                equal => equal,
                result => result
            );
        process
        begin
            wait for 50 ns;
            -- verifica se a = b
            operationselect <= "11";
            -- valores iguais
            ina <= "0110000101110101";
            inb <= "0110000101110101";

            wait for 50 ns;
            -- a maior que b sendo a e b positivos
            ina <= "0100110101001100";
            inb <= "0001000100111010";

            wait for 50 ns;
            -- verifica a > b
            operationselect <= "10";
            -- a maior que b sendo a e b positivos
            ina <= "0100110101001100";
            inb <= "0001000100111010";

            wait for 50 ns;
            -- a maior que b sendo a negativo
            ina <= "1100110111011000";
            inb <= "0001000100111010";
            
            wait for 50 ns;
            -- a maior que b sendo b negativo
            ina <= "0000110111011000";
            inb <= "1001000100111010";

            wait for 50 ns;
            -- a maior que b sendo b negativo
            ina <= "0000110111011000";
            inb <= "1001000100111010";

            wait for 50 ns;
            -- a maior que b sendo a e b negativo
            ina <= "1010111100011000";
            inb <= "1001000100111010";

            wait for 50 ns;
            -- a menor que b sendo a e b positivo
            ina <= "0010000100110001";
            inb <= "0110110101001100";

            wait for 50 ns;
            -- a menor que b sendo a negativo
            ina <= "1010100100100101";
            inb <= "0110110101001100";

            wait for 50 ns;
            -- a menor que b sendo b negativo
            ina <= "0100010101110101";
            inb <= "1110110101001100";

            wait for 50 ns;
            -- a menor que b sendo a e b negativo
            ina <= "1001100111000101";
            inb <= "1110110101001100";

            wait for 50 ns;
            wait;
        end process;
    end architecture;