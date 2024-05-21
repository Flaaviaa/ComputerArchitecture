library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculadoraprogramavel is
    port(
        rst : in std_logic := '0';
        clk : in std_logic := '0';
        estado : out unsigned(1 downto 0) := "00";
        instrucao : out unsigned(15 downto 0) := "0000000000000000";
        saida_bancoregistradores_reg1 : out unsigned(15 downto 0) := "0000000000000000";
        saida_bancoregistradores_reg2 : out unsigned(15 downto 0) := "0000000000000000";
        saida_ula : out unsigned(15 downto 0) := "0000000000000000"

    );
end entity;

architecture a_calculadoraprogramavel of calculadoraprogramavel is
    signal instrucao_signal : unsigned(15 downto 0) := "0000000000000000";
    signal saida_ula_signal : unsigned(15 downto 0) := "0000000000000000";
    signal estado_signal : unsigned(1 downto 0) := "00";

    signal contador : unsigned(15 downto 0) := "0000000000000000";
    signal UC_instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal UC_select_mux_input_regs : std_logic := '0';
    signal UC_select_ula_op : unsigned(1 downto 0) := "00";
    signal UC_select_mux_ula : std_logic := '0';
    signal UC_instrucao_beq : std_logic := '0';
    signal UC_instrucao_salto_relativo : std_logic := '0';
    signal UC_reg_wr_en : std_logic := '0';
    signal UC_wr_reg_andress : unsigned(2 downto 0) := "000";
    signal UC_selec_reg1 :  unsigned(2 downto 0) := "000"; -- seleciona registrador 1 que vai na ula
    signal UC_selec_reg2 :  unsigned(2 downto 0) := "000"; -- seleciona registrador 2 que vai no mux
    signal UC_registrador_para_salvar :  unsigned(2 downto 0) := "000";
    signal constante_instrucao : unsigned(15 downto 0) := "0000000000000000";
    signal constante_delta_salto_branch :  unsigned(6 downto 0) := "0000000";
    signal constante_ula : unsigned(15 downto 0) := "0000000000000000"; -- constante que entra no valor B da ula
    signal PC_incrementar_pc : std_logic := '0';
    signal PC_saltar : std_logic := '0';
    signal PC_endereco_entrada_pc : unsigned(6 downto 0) := "0000000";
    signal PC_endereco_saida : unsigned(6 downto 0) := "0000000";
    signal PC_erro_endereco : std_logic := '0';
    signal PC_somar : std_logic := '0';
    signal ROM_read_en : std_logic := '0';
    signal ROM_endereco : unsigned(6 downto 0) := "0000000";
    signal ROM_instrucao_saida : unsigned(15 downto 0) := "0000000000000000";

    signal REG_INSTR_wr_en : std_logic := '0';
    signal REG_INSTR_data_in :unsigned(15 downto 0) := "0000000000000000";
    signal REG_INSTR_data_out : unsigned(15 downto 0) := "0000000000000000";
    signal acumulador_atualizar : std_logic := '0';
    signal acumulador_entrada : unsigned(15 downto 0) := "0000000000000000";
    signal acumulador_saida : unsigned(15 downto 0) := "0000000000000000";

    signal BANCO_REG_reg_select_1 : unsigned(2 downto 0) := "000";
    signal BANCO_REG_reg_select_2 : unsigned(2 downto 0) := "000";     
    signal BANCO_REG_regWrite : unsigned(2 downto 0);
    signal BANCO_REG_entr : unsigned(15 downto 0) := "0000000000000000";  
    signal BANCO_REG_wr_en : std_logic := '0';
    signal BANCO_REG_reg_data1 : unsigned(15 downto 0) := "0000000000000000";  
    signal BANCO_REG_reg_data2 : unsigned(15 downto 0) := "0000000000000000";
    
    signal mutex_ula_controle : std_logic := '0';
    signal mutex_ula_entradazero : unsigned(15 downto 0) := "0000000000000000";
    signal mutex_ula_entradaum : unsigned(15 downto 0) := "0000000000000000";
    signal mutex_ula_saida  : unsigned(15 downto 0) := "0000000000000000";

    signal mutex_reg_controle : std_logic := '0';
    signal mutex_reg_entradazero : unsigned(15 downto 0) := "0000000000000000";
    signal mutex_reg_entradaum : unsigned(15 downto 0) := "0000000000000000";
    signal mutex_reg_saida  : unsigned(15 downto 0) := "0000000000000000";

    signal ULA_ina :  unsigned(15 downto 0) := "0000000000000000";
    signal ULA_inb :  unsigned(15 downto 0) := "0000000000000000";
    signal ULA_operationselect :  unsigned(1 downto 0) := "00";
    signal ULA_carry :  std_logic := '0';
    signal ULA_overflow :  std_logic := '0';
    signal ULA_biggest :  std_logic := '0';
    signal ULA_equal :  std_logic := '0';


    component UC is
        port(
            instrucao : in unsigned(15 downto 0);
            select_mux_input_regs : out std_logic; -- 
            select_ula_op : out unsigned(1 downto 0);
            select_mux_ula : out std_logic; -- seleciona 1 para constante e 0 para registrador
            instrucao_beq : out std_logic;
            instrucao_salto_relativo : out std_logic;
            reg_wr_en : out std_logic; 
            selec_reg1 : out unsigned(2 downto 0);
            selec_reg2 : out unsigned(2 downto 0);
            registrador_para_salvar : out unsigned(2 downto 0)
        );
    end component;
    component constante is
        port(
            instrucao : in unsigned(15 downto 0);
            delta_salto_branch : out unsigned(6 downto 0);
            constante_ula : out unsigned(15 downto 0)
        );
    end component;
    component PC is
        port(
            rst : in std_logic;
            clk : in std_logic;
            wr_en : in std_logic;
            saltar : in std_logic;
            somar : in std_logic;
            endereco_entrada : in unsigned(6 downto 0);
            endereco_saida : out unsigned(6 downto 0);
            erro_endereco : out std_logic := '0'
        );
    end component;
    component rom is
        port(
            clk : in std_logic;
            read_en  : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado : out unsigned(15 downto 0)
        );
    end component;
    component maquina_de_estados is
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            saida    : out unsigned(1 downto 0)
        );
    end component;
    component acumulador is
        port(
            atualizar : in std_logic;
            entrada : in unsigned(15 downto 0);
            saida : out unsigned(15 downto 0)
        );
    end component;
    component reg16bits is
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    component banco_de_registradores is
        port (  
            reg_select_1      : in unsigned(2 downto 0);
            reg_select_2      : in unsigned(2 downto 0);     
            regWrite          : in unsigned(2 downto 0);
            entr             : in unsigned(15 downto 0);
            wr_en             : in std_logic;
            clk               : in std_logic;
            rst               : in std_logic;
            reg_data1         : out unsigned(15 downto 0) := "0000000000000000";  
            reg_data2         : out unsigned(15 downto 0) := "0000000000000000" 
        );
    end component;
    component mutex16bits2vias
        port(
            controle : in std_logic := '0';
            entradazero : in unsigned(15 downto 0) := "0000000000000000";
            entradaum : in unsigned(15 downto 0) := "0000000000000000";
            saida : out unsigned(15 downto 0)
        );
    end component;
    component ULA is
        port (
            ina : in unsigned(15 downto 0);
            inb : in unsigned(15 downto 0);
            operationselect : in unsigned(1 downto 0);
            carry : out std_logic;
            overflow : out std_logic;
            biggest : out std_logic;
            equal : out std_logic;
            result : out unsigned(15 downto 0)
        );
    end component;
    begin

    ULA_instance : ULA port map(
        ina => ULA_ina, -- OK
        inb => ULA_inb, -- OK
        operationselect => ULA_operationselect, -- OK
        carry => ULA_carry,
        overflow => ULA_overflow,
        biggest => ULA_biggest,
        equal => ULA_equal, -- OK
        result => saida_ula_signal -- OK
        );
    UC_instance : UC port map(
        instrucao => UC_instrucao , --OK
        select_mux_input_regs => UC_select_mux_input_regs , --OK
        select_ula_op => UC_select_ula_op ,--OK
        select_mux_ula => UC_select_mux_ula ,--OK
        instrucao_beq => UC_instrucao_beq ,--ok
        instrucao_salto_relativo => UC_instrucao_salto_relativo,--ok
        reg_wr_en => UC_reg_wr_en ,--ok
        selec_reg1 => UC_selec_reg1 ,--ok
        selec_reg2 => UC_selec_reg2 ,--ok
        registrador_para_salvar => UC_registrador_para_salvar --ok
        );
    constante_instance : constante port map(
        instrucao => constante_instrucao,--ok
        delta_salto_branch => constante_delta_salto_branch,--ok
        constante_ula => constante_ula--ok
        );

    PC_instance : PC port map(
        rst => rst,
        clk => clk,
        wr_en => PC_incrementar_pc,--ok
        saltar => PC_saltar,--ok
        somar => PC_somar,--ok
        endereco_entrada => PC_endereco_entrada_pc,--ok
        endereco_saida => PC_endereco_saida,--ok
        erro_endereco => PC_erro_endereco--n usado
        );

    rom_instance : rom port map(
        clk => clk,
        read_en => ROM_read_en,--ok
        endereco => ROM_endereco,--ok
        dado => ROM_instrucao_saida--ok
        );

    maquina_de_estados_instance : maquina_de_estados port map(
        clk => clk,
        rst => rst,
        wr_en => '1',
        saida => estado_signal
        );

    acumulador_instance : acumulador port map(
        atualizar => acumulador_atualizar,--ok
        entrada => acumulador_entrada,--ok
        saida => acumulador_saida--ok
        );

    reg16bits_instance : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => REG_INSTR_wr_en,--ok
        data_in => REG_INSTR_data_in,--ok
        data_out => REG_INSTR_data_out--ok
        );  

    banco_de_registradores_instance : banco_de_registradores port map(
        reg_select_1 => BANCO_REG_reg_select_1,--ok
        reg_select_2 => BANCO_REG_reg_select_2,--ok
        regWrite => BANCO_REG_regWrite,--ok
        entr => BANCO_REG_entr,--ok
        wr_en => BANCO_REG_wr_en,--ok
        clk => clk,
        rst => rst,
        reg_data1 => BANCO_REG_reg_data1,--ok
        reg_data2 => BANCO_REG_reg_data2--ok
        );
    
    mutex16bits2vias_ula_instance : mutex16bits2vias port map(
        controle => mutex_ula_controle,--ok
        entradazero => mutex_ula_entradazero,--ok
        entradaum => mutex_ula_entradaum,--ok
        saida => mutex_ula_saida--ok
        );
    mutex16bits2vias_reg_instance : mutex16bits2vias port map(
        controle => mutex_reg_controle,--ok
        entradazero => mutex_reg_entradazero,--ok
        entradaum => mutex_reg_entradaum, --ok
        saida => mutex_reg_saida --ok
        );

-- CONEXOES
        -- ROM
        ROM_endereco <= PC_endereco_saida;
        -- PC
        PC_endereco_entrada_pc <= constante_delta_salto_branch;
        -- REGISTRADOR DE INSTRUCAO
        instrucao_signal <= REG_INSTR_data_out;
        REG_INSTR_data_in <= ROM_instrucao_saida;
        -- UC
        UC_instrucao <= instrucao_signal;
        -- CONSTANTE
        constante_instrucao <= instrucao_signal;
        -- BANCO DE REGISTRADORES
        BANCO_REG_reg_select_1 <= UC_selec_reg1;
        BANCO_REG_reg_select_2 <= UC_selec_reg2;
        BANCO_REG_regWrite <= UC_registrador_para_salvar;
        BANCO_REG_entr <= mutex_reg_saida;
        -- ULA
        ULA_ina <= BANCO_REG_reg_data1;
        ULA_inb <= mutex_ula_saida;
        ULA_operationselect <= UC_select_ula_op;
        acumulador_entrada <= saida_ula_signal;
        -- MUTEX REG E ULA
        mutex_reg_entradaum <= saida_ula_signal;
        mutex_reg_entradazero <= "0000000000000000";
        mutex_reg_controle <= UC_select_mux_input_regs;
        mutex_ula_entradazero <= BANCO_REG_reg_data2;
        mutex_ula_entradaum <= constante_ula;
        mutex_ula_controle <= UC_select_mux_ula;
        


-- ESTADO DE FETCH 
        -- ler a ROM  
        ROM_read_en <= '1' when estado_signal = "00" else '0';


-- escrever no registrador de instrução

-- ESTADO DE DECODE
        REG_INSTR_wr_en <= '1' when estado_signal = "01" else '0';

-- ESTADO DE EXECUTE
        -- realiza operação
            -- a ula faz automático, só conectar os fios 
        -- incrementar pc
        PC_incrementar_pc <= '1' when estado_signal = "10" else '0';
        PC_saltar <= '1' when UC_instrucao_beq = '1' and ULA_equal = '1' else '0';
        PC_somar <= UC_instrucao_salto_relativo;
        acumulador_atualizar <= '1' when estado_signal = "10" else '0';
        BANCO_REG_wr_en <= '1' when UC_reg_wr_en = '1' and estado_signal = "10" else '0' ;

instrucao <= instrucao_signal;
saida_ula <= saida_ula_signal;
estado <= estado_signal;
end architecture;