library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXECUTE_PACKAGE is
    port(
        -- controle
        clk : in std_logic := '0';
        rst : in std_logic := '0';
        estado : in unsigned(1 downto 0) := "00";
        -- entrada
        exe_in_ram_dado : in unsigned(15 downto 0) := "0000000000000000";
        exe_ram_wr_en : in std_logic := '0';
        exe_ram_endereco : in unsigned(15 downto 0) := "0000000000000000";
        
        exe_select_mux_pc : in unsigned(1 downto 0) := "00";
        exe_select_op_ula : in unsigned(1 downto 0) := "00";
        exe_ina_ula : in unsigned(15 downto 0) := "0000000000000000";
        exe_inb_ula : in unsigned(15 downto 0) := "0000000000000000";
        exe_bit5 : in std_logic := '0';
        exe_regflags_wr_en : in std_logic := '0';
        exe_regula_wr_en : in std_logic := '0';
        -- saída
        exe_result_ula : out unsigned(15 downto 0) := "0000000000000000";
        exe_saida_reg : out unsigned(15 downto 0) := "0000000000000000";
        exe_saida_mux_pc : out std_logic := '0';
        exe_saida_ram : out unsigned(15 downto 0) := "0000000000000000";
        exe_erro_ram : out std_logic := '0'
    );
end entity;

architecture A_EXECUTE_PACKAGE of EXECUTE_PACKAGE is
    signal signal_ina : unsigned(15 downto 0) := "0000000000000000";
    signal signal_inb : unsigned(15 downto 0) := "0000000000000000";
    signal signal_operacaozeraula : std_logic := '0';
    signal signal_operationselect : unsigned(1 downto 0) := "00";
    signal signal_overflow : std_logic := '0';
    signal signal_negativo : std_logic := '0';
    signal signal_zero : std_logic := '0';
    signal signal_resultado_ula : unsigned(15 downto 0) := "0000000000000000";
    signal REG_wr_en : std_logic := '0';
    signal signal_saida_bit5 : std_logic := '0';
    signal signal_less_out : std_logic := '0';
    signal signal_overflow_out : std_logic := '0';
    signal signal_negativo_out : std_logic := '0';
    signal signal_zero_out : std_logic := '0';
    signal erro_ram : std_logic := '0';

    signal wr_en_ram : std_logic := '0';
    signal signal_exe_saida_mux_pc : std_logic := '0';
    
    component ram is
        port(
            clk      : in std_logic := '0';
            endereco : in unsigned(15 downto 0):= "0000000000000000";
            wr_en    : in std_logic := '0';
            dado_in  : in unsigned(15 downto 0):= "0000000000000000";
            dado_out : out unsigned(15 downto 0):= "0000000000000000";
            acess_error : out std_logic := '0'
        );
        end component;
    component ULA is
        port(
            ina : in unsigned(15 downto 0) := "0000000000000000";
            inb : in unsigned(15 downto 0) := "0000000000000000";
            operationselect : in unsigned(1 downto 0) := "00";
            overflow : out std_logic := '0';
            negativo : out std_logic := '0';
            result : out unsigned(15 downto 0) := "0000000000000000"
            
        );
    end component;

    component reg16bits is
        port( clk      : in std_logic := '0';
              rst      : in std_logic := '0';
              wr_en    : in std_logic := '0';
              data_in  : in unsigned(15 downto 0) := "0000000000000000";
              data_out : out unsigned(15 downto 0) := "0000000000000000"
        );
        end component;
    
    component regflags is
        port( 
            clk      : in std_logic := '0';
            rst      : in std_logic := '0';
            wr_en    : in std_logic := '0';
            overflow_in  : in std_logic := '0';
            negativo_in  : in std_logic := '0';
            zero_in  : in std_logic := '0';
            bit5_in : in std_logic := '0';
            less_out : out std_logic := '0';
            overflow_out : out std_logic := '0';
            negativo_out : out std_logic := '0';
            zero_out : out std_logic := '0';
            bit5_out : out std_logic := '0'
    );
    end component;

    begin
    ram_instance : ram port map(
        clk => clk,
        endereco => exe_ram_endereco,
        wr_en => wr_en_ram,
        dado_in => exe_in_ram_dado,
        dado_out => exe_saida_ram,
        acess_error => erro_ram
    );
    ULA_instance : ULA port map(
        ina => signal_ina,
        inb => signal_inb,
        operationselect => exe_select_op_ula,
        overflow => signal_overflow,
        negativo => signal_negativo,
        result => signal_resultado_ula
    );
    REG_instance : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => exe_regula_wr_en,
        data_in => signal_resultado_ula,
        data_out => exe_saida_reg
    );
    REGFLAGS_instance : regflags port map(
        clk => clk,
        rst => rst,
        wr_en => exe_regflags_wr_en,
        overflow_in => signal_overflow,
        negativo_in => signal_negativo,
        zero_in => signal_zero,
        bit5_in => exe_bit5,
        less_out => signal_less_out,
        overflow_out => signal_overflow_out,
        negativo_out => signal_negativo_out,
        zero_out => signal_zero_out,
        bit5_out => signal_saida_bit5
    );
    exe_erro_ram <= erro_ram;
    wr_en_ram <= exe_ram_wr_en;
    exe_result_ula <= signal_resultado_ula;
    exe_result_ula <= signal_resultado_ula;
    -- conexoes
    signal_ina <= exe_ina_ula;
    signal_inb <= exe_inb_ula;
    exe_saida_mux_pc <= signal_exe_saida_mux_pc;
    -- comportamento do mux de 4 entradas de 1 bit e uma saída
    signal_exe_saida_mux_pc <=  signal_overflow_out when exe_select_mux_pc = "01" else
                                not exe_bit5 when exe_select_mux_pc = "11" else
                                signal_negativo_out when exe_select_mux_pc = "10" else
                                '1';
    -- comportamento do component NOT do esquemático
    -- comportamento do mux de 2 entradas de 1 bit e uma saída
end architecture;