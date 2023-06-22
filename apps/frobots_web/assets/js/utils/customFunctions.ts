import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'

export default () => {
  // Create Frobot code
  Blockly.Blocks['frobot'] = {
    init: function () {
      this.appendDummyInput().appendField('Create Frobot')
      this.appendStatementInput('nested_blocks').setCheck(null)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setTooltip('frobot')
      this.setHelpUrl('')
    },
  }
  luaGenerator['frobot'] = function (block: any) {
    let code_new = ''
    var nestedBlock = block.getInputTargetBlock('nested_blocks')
    if (nestedBlock) {
      var code_nested = luaGenerator.blockToCode(nestedBlock)
      code_new = Array.isArray(code_nested) ? code_nested[0] : code_nested
      code_new = luaGenerator.prefixLines(code_new, '\t')
    }

    return `return function(state, ...)\n\tstate = state or {}${code_new ? `\n${code_new}` : `\n`}\treturn state\nend\n`
  }

  // Custom Return code
  Blockly.Blocks['custom_return'] = {
    init: function () {
      this.appendValueInput('return').setCheck(null).appendField('return')
      this.setPreviousStatement(true, null)
      this.setColour(230)
      this.setTooltip('Return any value')
      this.setHelpUrl('')
    },
  }
  luaGenerator['custom_return'] = function (block: any) {
    var inputBlock = block.getInputTargetBlock('INPUT')
    const result =
      luaGenerator.valueToCode(block, 'return', luaGenerator.ORDER_NONE) || 0
    var code = luaGenerator.blockToCode(inputBlock)
    code += `return ${result}\n`
    return code
  }

  // Damage function code
  Blockly.Blocks['damage'] = {
    init: function () {
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setOutput(true, null)
      this.appendDummyInput().appendField('Damage')
    },
  }
  luaGenerator['damage'] = function () {
    var code = 'damage()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['speed'] = {
    init: function () {
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setOutput(true, null)
      this.appendDummyInput().appendField('Speed')
    },
  }
  luaGenerator['speed'] = function () {
    var code = 'speed()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['drive'] = {
    init: function () {
      this.appendDummyInput().appendField('Drive')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('speed').setCheck(null).appendField('speed')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['drive'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const speed =
      luaGenerator.valueToCode(block, 'speed', luaGenerator.ORDER_NONE) || 0
    var code = `drive(${degree},${speed})\n`
    return code
  }

  Blockly.Blocks['cannon'] = {
    init: function () {
      this.appendDummyInput().appendField('Cannon')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('range').setCheck(null).appendField('range')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['cannon'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const range =
      luaGenerator.valueToCode(block, 'range', luaGenerator.ORDER_NONE) || 0
    var code = `cannon(${degree},${range})\n`
    return code
  }

  Blockly.Blocks['scan'] = {
    init: function () {
      this.appendDummyInput().appendField('Scan')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('resolution')
        .setCheck(null)
        .appendField('resolution')
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator['scan'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const resolution =
      luaGenerator.valueToCode(block, 'resolution', luaGenerator.ORDER_NONE) ||
      0
    var code = `scan(${degree},${resolution})`
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['xlocation'] = {
    init: function () {
      this.setOutput(true, 'String')
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.appendDummyInput().appendField('X Location')
    },
  }
  luaGenerator['xlocation'] = function () {
    var code = 'loc_x()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['ylocation'] = {
    init: function () {
      this.setOutput(true, 'String')
      this.setColour(230)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.appendDummyInput().appendField('Y Location')
    },
  }
  luaGenerator['ylocation'] = function () {
    var code = 'loc_y()'
    return [code, luaGenerator.ORDER_NONE]
  }

  /// multi
  Blockly.Blocks['table_create'] = {
    init: function () {
      this.appendDummyInput().appendField('Create Table')
      this.setOutput(true, 'Table')
      this.setColour(260)
      this.setTooltip('Creates a new table')
      this.setHelpUrl('')
    },
  }
  luaGenerator['table_create'] = function () {
    var code = '{}'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['insert_table_value'] = {
    init: function () {
      this.appendValueInput('TABLE')
        .setCheck('Table')
        .appendField('insert value into table')
      this.appendValueInput('KEY').setCheck(null).appendField('at key')
      this.appendValueInput('VALUE').setCheck(null).appendField('with value')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(260)
      this.setTooltip('Inserts a value into a table using a key')
      this.setHelpUrl('')
    },
  }
  luaGenerator['insert_table_value'] = function (block: any) {
    var table =
      luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) ||
      '{}'
    var key =
      luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""'
    var value =
      luaGenerator.valueToCode(block, 'VALUE', luaGenerator.ORDER_ATOMIC) ||
      '""'
    var code = table + '[' + key + '] = ' + value + '\n'
    return code
  }

  Blockly.Blocks['get_table_value'] = {
    init: function () {
      this.appendValueInput('TABLE')
        .setCheck('Table')
        .appendField('get value from table')
      this.appendValueInput('KEY').setCheck(null).appendField('by key')
      this.setOutput(true, null)
      this.setColour(260)
      this.setTooltip('Retrieves the value from a table using a key')
      this.setHelpUrl('')
    },
  }
  luaGenerator['get_table_value'] = function (block: any) {
    var table =
      luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) ||
      '{}'
    var key =
      luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""'
    var code = table + '[' + key + ']'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['set_table_value'] = {
    init: function () {
      this.appendValueInput('TABLE')
        .setCheck('Table')
        .appendField('set value in table')
      this.appendValueInput('KEY').setCheck(null).appendField('at key')
      this.appendValueInput('VALUE').setCheck(null).appendField('to')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(260)
      this.setTooltip('Sets the value of a table at the specified key')
      this.setHelpUrl('')
    },
  }
  luaGenerator['set_table_value'] = function (block: any) {
    var table =
      luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) ||
      '{}'
    var key =
      luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""'
    var value =
      luaGenerator.valueToCode(block, 'VALUE', luaGenerator.ORDER_ATOMIC) ||
      '""'
    var code = table + '[' + key + '] = ' + value + '\n'
    return code
  }

  Blockly.Blocks['remove_table_value'] = {
    init: function () {
      this.appendValueInput('TABLE')
        .setCheck('Table')
        .appendField('remove value from table')
      this.appendValueInput('KEY').setCheck(null).appendField('at key')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(260)
      this.setTooltip('Removes a value from a table at the specified key')
      this.setHelpUrl('')
    },
  }
  luaGenerator['remove_table_value'] = function (block: any) {
    var table =
      luaGenerator.valueToCode(block, 'TABLE', luaGenerator.ORDER_ATOMIC) ||
      '{}'
    var key =
      luaGenerator.valueToCode(block, 'KEY', luaGenerator.ORDER_ATOMIC) || '""'
    var code = table + '[' + key + '] = nil\n'
    return code
  }

  Blockly.Blocks['math_atan2'] = {
    init: function () {
      this.appendValueInput('Y').setCheck('Number').appendField('atan2 of y')
      this.appendValueInput('X').setCheck('Number').appendField('x')
      this.setOutput(true, 'Number')
      this.setColour(230)
      this.setTooltip('Returns the arc tangent of y/x in radians')
      this.setHelpUrl(
        'https://www.lua.org/manual/5.4/manual.html#pdf-math.atan2'
      )
    },
  }
  luaGenerator['math_atan2'] = function (block: any) {
    var y =
      luaGenerator.valueToCode(block, 'Y', luaGenerator.ORDER_ATOMIC) || '0'
    var x =
      luaGenerator.valueToCode(block, 'X', luaGenerator.ORDER_ATOMIC) || '0'
    var code = 'math.atan2(' + y + ', ' + x + ')'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['math_randomseed'] = {
    init: function () {
      this.appendValueInput('SEED')
        .setCheck(null)
        .appendField('set random seed to');
      this.setPreviousStatement(true, null);
      this.setNextStatement(true, null);
      this.setColour(230);
      this.setTooltip('Sets the seed for the random number generator');
      this.setHelpUrl('https://www.lua.org/manual/5.4/manual.html#pdf-math.randomseed');
    }
  }
  luaGenerator['math_randomseed'] = function (block: any) {
    var seed = luaGenerator.valueToCode(block, 'SEED', luaGenerator.ORDER_ATOMIC) || '0';
    var code = 'math.randomseed(' + seed + ')\n';
    return code;
  };

  Blockly.Blocks['os_time'] = {
    init: function () {
      this.appendDummyInput()
        .appendField("Current os time");
      this.setOutput(true, null);
      this.setColour(230);
      this.setTooltip("Returns the current time");
      this.setHelpUrl("https://www.lua.org/manual/5.4/manual.html#pdf-os.time");
    }
  }
  luaGenerator['os_time'] = function (block: any) {
    var code = 'os.time()';
    return [code, luaGenerator.ORDER_ATOMIC];
  };

  Blockly.Blocks['os_execute_sleep'] = {
    init: function () {
      this.appendValueInput('SECONDS')
        .setCheck('Number')
        .appendField('Sleep os for');
      this.appendDummyInput()
        .appendField('seconds');
      this.setOutput(true, null);
      this.setColour(230);
      this.setTooltip('Pauses the program execution for the specified number of seconds');
      this.setHelpUrl('');
    }
  }
  luaGenerator['os_execute_sleep'] = function (block: any) {
    var seconds = luaGenerator.valueToCode(block, 'SECONDS', luaGenerator.ORDER_ATOMIC) || '1';
    var code = 'os.execute("sleep " .. tonumber(' + seconds + '))\n';

    return [code, luaGenerator.ORDER_ATOMIC];
  };

  Blockly.Blocks['repeat_until'] = {
    init: function () {
      this.appendDummyInput()
        .appendField('repeat')
        .setAlign(Blockly.ALIGN_CENTRE);
      this.appendStatementInput('nested_blocks')
        .setCheck(null)
      this.appendValueInput('CONDITION')
        .setCheck(null)
        .setAlign(Blockly.ALIGN_CENTRE)
        .appendField('until');
      this.setPreviousStatement(true, null);
      this.setNextStatement(true, null);
      this.setColour(120);
      this.setTooltip('Repeats the enclosed blocks until the specified condition is true');
      this.setHelpUrl('');
    }
  }
  luaGenerator['repeat_until'] = function (block: any) {
    var doCode = '';
    var condition = luaGenerator.valueToCode(block, 'CONDITION', luaGenerator.ORDER_ATOMIC) || 'false';
    var nestedBlock = block.getInputTargetBlock('nested_blocks')
    if (nestedBlock) {
      var code_nested = luaGenerator.blockToCode(nestedBlock)
      doCode = Array.isArray(code_nested) ? code_nested[0] : code_nested
      doCode = luaGenerator.prefixLines(doCode, '\t')
    }

    var code = 'repeat\n' + doCode + 'until ' + condition + '\n';
    return code;
  };

  Blockly.Blocks['create_object'] = {
    init: function () {
      this.appendDummyInput()
        .appendField('Create Object')
        .appendField(new Blockly.FieldVariable('object'), 'object')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(210)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }

  luaGenerator['create_object'] = function (block) {
    var variable_object = luaGenerator.variableDB_.getName(
      block.getFieldValue('object'),
      Blockly.Variables.NAME_TYPE
    )
    return variable_object + ' = {};\n'
  }

  Blockly.Blocks['set_object_property'] = {
    init: function () {
      this.appendValueInput('object')
        .setCheck(null)
        .appendField('Set property of object')
      this.appendDummyInput()
        .appendField('.')
        .appendField(new Blockly.FieldTextInput('property'), 'property')
      this.appendValueInput('value').setCheck(null).appendField('to')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(210)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }

  luaGenerator['set_object_property'] = function (block) {
    var value_object = luaGenerator.valueToCode(
      block,
      'object',
      luaGenerator.ORDER_ATOMIC
    )
    var text_property = block.getFieldValue('property')
    var value_value = luaGenerator.valueToCode(
      block,
      'value',
      luaGenerator.ORDER_ATOMIC
    )

    return value_object + '.' + text_property + ' = ' + value_value + ';\n'
  }

  Blockly.Blocks['get_object_property'] = {
    init: function () {
      this.appendValueInput('object').setCheck(null).appendField('Get property')
      this.appendDummyInput()
        .appendField('.')
        .appendField(new Blockly.FieldTextInput('property'), 'property')
      this.setOutput(true, null)
      this.setColour(210)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }

  luaGenerator['get_object_property'] = function (block) {
    var value_object = luaGenerator.valueToCode(
      block,
      'object',
      luaGenerator.ORDER_ATOMIC
    )
    var text_property = block.getFieldValue('property')

    return [value_object + '.' + text_property, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['set_variable_type'] = {
    init: function () {
      this.appendDummyInput()
        .appendField(
          new Blockly.FieldDropdown([
            ['Local', 'local'],
            ['Global', 'global'],
          ]),
          'TYPE'
        )
        .appendField(new Blockly.FieldVariable('temp'), 'VAR')
      this.appendValueInput('VALUE').setCheck(null).appendField('value')
      this.setColour(330)
      this.setTooltip('')
      this.setHelpUrl('')
      this.setInputsInline(true)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
    },
  }

  luaGenerator['set_variable_type'] = function (block) {
    var variable = luaGenerator.variableDB_.getName(
      block.getFieldValue('VAR'),
      Blockly.VARIABLE_CATEGORY_NAME
    )
    var type = block.getFieldValue('TYPE')
    var value =
      luaGenerator.valueToCode(block, 'VALUE', luaGenerator.ORDER_ATOMIC) ||
      'nil'

    var code = ''
    if (type === 'local') {
      code += 'local ' + variable + ' = ' + value + ';\n'
    } else if (type === 'global') {
      code += variable + ' = ' + value + ';\n'
    }

    return code
  }
}
