library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- selectoption - seleciona a operação a ser feita, que são
-- 00 - soma
-- 01 - subtracao
-- 10 - COMP
        -- tanto carry como overflow fazem : a maior que b, a igual b


entity ULA is
    port (
        ina : in unsigned(15 downto 0) := "0000000000000000";
        inb : in unsigned(15 downto 0) := "0000000000000000";
        operationselect : in unsigned(1 downto 0) := "00";
        overflow : out std_logic := '0';
        negativo : out std_logic := '0';
        result : out unsigned(15 downto 0) := "0000000000000000"
    );
end entity;

architecture a_ULA of ULA is
    signal sing_ina,sing_inb : unsigned(16 downto 0) := B"0000_0000_0000_0000_0";
    signal signal_overflow,signal_negativo,signal_zero : std_logic := '0';
    signal salvo_overflow,salvo_negativo,salvo_zero : std_logic := '0';
    signal sub : unsigned(16 downto 0) := "00000000000000000";
    signal soma : unsigned(16 downto 0) := "00000000000000000";
    signal operacaozeraula : std_logic := '0';
    signal signal_result : unsigned(15 downto 0) := "0000000000000000";

    begin
        sing_ina <= '0' & ina;

        sing_inb <= '0' & inb;

        soma <= sing_ina + sing_inb;

        sub <= sing_ina - sing_inb;

        operacaozeraula <= '1' when operationselect = "10" or operationselect = "11" else '0';

        signal_result <=   soma(15 downto 0) when operationselect = "00" else
                    sub(15 downto 0) when operationselect = "01" else
                    "0000000000000000";

        signal_overflow <=  '1' when (operationselect = "00" or operationselect = "10") and ina(15) = '0' and inb(15) = '0' and soma(15) = '1' else -- caso a e b +
                            '1' when (operationselect = "00" or operationselect = "10") and ina(15) = '1' and inb(15) = '1' and soma(15) = '0' else-- caso a e b -
                            '1' when (operationselect = "01" or operationselect = "10") and ina(15) = '0' and inb(15) = '1' and sub(15) = '1' else
                            '1' when (operationselect = "01" or operationselect = "10") and ina(15) = '1' and inb(15) = '0' and sub(15) = '0' else
                            '0';
        
        signal_negativo <=  '1' when sub(15 downto 0) = "0000000000000000";

        result <= signal_result;
        overflow <= signal_overflow ;
        negativo <= signal_negativo;

    end architecture;
