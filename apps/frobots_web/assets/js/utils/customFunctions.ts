import Blockly from 'blockly'
import { luaGenerator } from 'blockly/lua'

export default () => {
  // Create Frobot code
  Blockly.Blocks['frobot'] = {
    init: function () {
      this.appendDummyInput().appendField('Create Frobot')
      this.appendValueInput('initial_state')
        .setCheck('String')
        .appendField('Initial state')
      this.appendStatementInput('nested_blocks').setCheck(null)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setTooltip('frobot')
      this.setHelpUrl('')
    },
    onchange: function () {
      if (this.workspace && !this.workspace.isFlyout) {
        // Create variable state if not exists
        if (!Blockly.Variables.getVariable(this.workspace, 'state')) {
          this.workspace.createVariable('state')
        }
      }
    },
  }
  luaGenerator.forBlock['frobot'] = function (block: any) {
    var statements = luaGenerator.statementToCode(block, 'nested_blocks') || ''
    var state = luaGenerator.valueToCode(
      block,
      'initial_state',
      luaGenerator.ORDER_NONE
    )

    return (
      'return function(state, ...)\n\tstate = state or {}\n' +
      `${state ? '\tset_FSM_state(' + state + ')\n' : ''}` +
      statements +
      '\treturn state \nend\n'
    )
  }

  // Exit block code
  Blockly.Blocks['exit_block'] = {
    init: function () {
      this.appendDummyInput().appendField('Exit Block')
      this.appendDummyInput('operator')
        .appendField(
          new Blockly.FieldDropdown([
            ['if', 'if'],
            ['else if', 'elseif'],
            ['else', 'else'],
          ]),
          'operator'
        )
        .setAlign(Blockly.inputs.Align.LEFT)
      this.appendValueInput('condition')
        .setCheck('Boolean')
        .appendField('condition')
        .setAlign(Blockly.inputs.Align.CENTRE)
      this.appendValueInput('state')
        .setCheck('String')
        .appendField('new state')
        .setAlign(Blockly.inputs.Align.RIGHT)
      this.appendStatementInput('nested_blocks')
        .setCheck(null)
        .appendField('do')
      this.setInputsInline(true)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(210)
      this.setTooltip('')
      this.setHelpUrl('')
    },
    onchange: function () {
      var operator = this.getFieldValue('operator')
      if (operator && operator === 'else') {
        this.getInput('condition').setVisible(false)
        this.getInput('state').setAlign(Blockly.inputs.Align.CENTRE)
      } else {
        this.getInput('condition')
          .setAlign(Blockly.inputs.Align.CENTRE)
          .setVisible(true)
        this.getInput('state').setAlign(Blockly.inputs.Align.RIGHT)
      }
    },
  }
  luaGenerator.forBlock['exit_block'] = function (block: any) {
    var operator = block.getFieldValue('operator') || 'if'
    var condition =
      luaGenerator.valueToCode(block, 'condition', luaGenerator.ORDER_NONE) ||
      'false'
    var new_state =
      luaGenerator.valueToCode(block, 'state', luaGenerator.ORDER_NONE) || ''
    var statements = luaGenerator.statementToCode(block, 'nested_blocks') || ''
    let doesLoopEnd = true

    // check if any other exit_block attached to this
    var nextConnection = block.nextConnection
    if (nextConnection.isConnected()) {
      var nextBlock = nextConnection.targetBlock()
      var nextBlockType = nextBlock.type
      var fieldValue = nextBlock.getFieldValue('operator')

      // if the next block exit_block
      if (nextBlockType == 'exit_block') {
        // if next block is a continuation, current loop should not end
        if (['elseif', 'else'].includes(fieldValue)) {
          doesLoopEnd = false
        }

        // make sure the loop ends if current operator is else
        if (operator === 'else') {
          doesLoopEnd = true
        }
      }
    }

    let code = ''

    if (['if', 'elseif'].includes(operator)) {
      code =
        `${operator} ` +
        condition +
        ' then\n' +
        '\tset_FSM_state(' +
        new_state +
        ')\n' +
        statements +
        `\treturn state \n${doesLoopEnd ? 'end\n' : ''}`
    } else {
      code =
        `${operator}\n` +
        '\tset_FSM_state(' +
        new_state +
        ')\n' +
        statements +
        `\treturn state \n${doesLoopEnd ? 'end\n' : ''}`
    }

    return code
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
  luaGenerator.forBlock['custom_return'] = function (block: any) {
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
  luaGenerator.forBlock['damage'] = function () {
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
  luaGenerator.forBlock['speed'] = function () {
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
  luaGenerator.forBlock['drive'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const speed =
      luaGenerator.valueToCode(block, 'speed', luaGenerator.ORDER_NONE) || 0
    var code = `drive(${degree}, ${speed})\n`
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
  luaGenerator.forBlock['cannon'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const range =
      luaGenerator.valueToCode(block, 'range', luaGenerator.ORDER_NONE) || 0
    var code = `cannon(${degree}, ${range})\n`
    return code
  }

  Blockly.Blocks['cannon_2'] = {
    init: function () {
      this.appendDummyInput().appendField('Cannon')
      this.appendValueInput('degree').setCheck(null).appendField('degree')
      this.appendValueInput('range').setCheck(null).appendField('range')
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['cannon_2'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const range =
      luaGenerator.valueToCode(block, 'range', luaGenerator.ORDER_NONE) || 0
    var code = `cannon(${degree}, ${range})`
    return [code, luaGenerator.ORDER_ATOMIC]
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
  luaGenerator.forBlock['scan'] = function (block: any) {
    const degree =
      luaGenerator.valueToCode(block, 'degree', luaGenerator.ORDER_NONE) || 0
    const resolution =
      luaGenerator.valueToCode(block, 'resolution', luaGenerator.ORDER_NONE) ||
      0
    var code = `scan(${degree}, ${resolution})`
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
  luaGenerator.forBlock['xlocation'] = function () {
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
  luaGenerator.forBlock['ylocation'] = function () {
    var code = 'loc_y()'
    return [code, luaGenerator.ORDER_ATOMIC]
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
  luaGenerator.forBlock['math_atan2'] = function (block: any) {
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
        .appendField('set random seed to')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('Sets the seed for the random number generator')
      this.setHelpUrl(
        'https://www.lua.org/manual/5.4/manual.html#pdf-math.randomseed'
      )
    },
  }
  luaGenerator.forBlock['math_randomseed'] = function (block: any) {
    var seed =
      luaGenerator.valueToCode(block, 'SEED', luaGenerator.ORDER_ATOMIC) || '0'
    var code = 'math.randomseed(' + seed + ')\n'
    return code
  }

  Blockly.Blocks['os_time'] = {
    init: function () {
      this.appendDummyInput().appendField('Current os time')
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip('Returns the current time')
      this.setHelpUrl('https://www.lua.org/manual/5.4/manual.html#pdf-os.time')
    },
  }
  luaGenerator.forBlock['os_time'] = function (block: any) {
    var code = 'os.time()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['os_execute_sleep'] = {
    init: function () {
      this.appendValueInput('SECONDS')
        .setCheck('Number')
        .appendField('Sleep os for')
      this.appendDummyInput().appendField('seconds')
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip(
        'Pauses the program execution for the specified number of seconds'
      )
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['os_execute_sleep'] = function (block: any) {
    var seconds =
      luaGenerator.valueToCode(block, 'SECONDS', luaGenerator.ORDER_ATOMIC) ||
      '1'
    var code = 'os.execute("sleep " .. tonumber(' + seconds + '))\n'

    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['repeat_until'] = {
    init: function () {
      this.appendDummyInput()
        .appendField('repeat')
        .setAlign(Blockly.inputs.Align.CENTRE)
      this.appendStatementInput('nested_blocks').setCheck(null)
      this.appendValueInput('CONDITION')
        .setCheck(null)
        .setAlign(Blockly.inputs.Align.CENTRE)
        .appendField('until')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(120)
      this.setTooltip(
        'Repeats the enclosed blocks until the specified condition is true'
      )
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['repeat_until'] = function (block: any) {
    var doCode = ''
    var condition =
      luaGenerator.valueToCode(block, 'CONDITION', luaGenerator.ORDER_ATOMIC) ||
      'false'
    var nestedBlock = block.getInputTargetBlock('nested_blocks')
    if (nestedBlock) {
      var code_nested = luaGenerator.blockToCode(nestedBlock)
      doCode = Array.isArray(code_nested) ? code_nested[0] : code_nested
      doCode = luaGenerator.prefixLines(doCode, '\t')
    }

    var code = 'repeat\n' + doCode + 'until ' + condition + '\n'
    return code
  }

  Blockly.Blocks['set_cannon'] = {
    init: function () {
      this.appendValueInput('cannon_id')
        .setCheck('Number')
        .appendField('Set cannon')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['set_cannon'] = function (block: any) {
    const cannon_id =
      luaGenerator.valueToCode(block, 'cannon_id', luaGenerator.ORDER_NONE) || 0
    var code = `set_cannon(${cannon_id})\n`
    return code
  }

  Blockly.Blocks['set_scanner'] = {
    init: function () {
      this.appendValueInput('scanner_id')
        .setCheck('Number')
        .appendField('Set scanner')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['set_scanner'] = function (block: any) {
    const scanner_id =
      luaGenerator.valueToCode(block, 'scanner_id', luaGenerator.ORDER_NONE) ||
      0
    var code = `set_scanner(${scanner_id})\n`
    return code
  }

  // Blockly.Blocks['create_object'] = {
  //   init: function () {
  //     this.appendDummyInput()
  //       .appendField('Create Object')
  //       .appendField(new Blockly.FieldVariable('object'), 'object')
  //     this.setPreviousStatement(true, null)
  //     this.setNextStatement(true, null)
  //     this.setColour(210)
  //     this.setTooltip('')
  //     this.setHelpUrl('')
  //   },
  // }

  // luaGenerator.forBlock['create_object'] = function (block) {
  //   var variable_object = luaGenerator.nameDB_.getName(
  //     block.getFieldValue('object'),
  //     Blockly.Variables.NAME_TYPE
  //   )
  //   return variable_object + ' = {}\n'
  // }

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

  luaGenerator.forBlock['set_object_property'] = function (block: any) {
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

    return value_object + '.' + text_property + ' = ' + value_value + '\n'
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

  luaGenerator.forBlock['get_object_property'] = function (block: any) {
    var value_object = luaGenerator.valueToCode(
      block,
      'object',
      luaGenerator.ORDER_ATOMIC
    )
    var text_property = block.getFieldValue('property')

    return [value_object + '.' + text_property, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['change_object_property'] = {
    init: function () {
      this.appendDummyInput()
        .appendField('change')
        .appendField(new Blockly.FieldVariable('state'), 'object')
        .appendField('.')
        .appendField(new Blockly.FieldTextInput('property'), 'property')
        .appendField('using')
      this.appendDummyInput()
        .appendField(
          new Blockly.FieldDropdown([
            ['+', '+'],
            ['-', '-'],
            ['*', '*'],
            ['/', '/'],
            ['%', '%'],
          ]),
          'operator'
        )
        .appendField('by')
      this.appendValueInput('value').setCheck('Number')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(210)
      this.setTooltip('Arithmetic operation on an object property')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['change_object_property'] = function (block: any) {
    var objectName = luaGenerator.nameDB_.getName(
      block.getFieldValue('object'),
      Blockly.VARIABLE_CATEGORY_NAME
    )
    var objectProperty = block.getFieldValue('property')
    var operator = block.getFieldValue('operator')
    var changeValue = luaGenerator.valueToCode(
      block,
      'value',
      luaGenerator.ORDER_ATOMIC
    )

    return `${objectName}.${objectProperty} = ${objectName}.${objectProperty} ${operator} ${changeValue}\n`
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

  luaGenerator.forBlock['set_variable_type'] = function (block: any) {
    var variable = luaGenerator.nameDB_.getName(
      block.getFieldValue('VAR'),
      Blockly.VARIABLE_CATEGORY_NAME
    )
    var type = block.getFieldValue('TYPE')
    var value =
      luaGenerator.valueToCode(block, 'VALUE', luaGenerator.ORDER_ATOMIC) ||
      'nil'

    var code = ''
    if (type === 'local') {
      code += 'local ' + variable + ' = ' + value + '\n'
    } else if (type === 'global') {
      code += variable + ' = ' + value + '\n'
    }

    return code
  }

  Blockly.Blocks['set_state_property'] = {
    init: function () {
      this.appendDummyInput().appendField('Set state .')
      this.appendDummyInput().appendField(
        new Blockly.FieldTextInput('property'),
        'property'
      )
      this.appendValueInput('value').setCheck(null).appendField('to')
      this.setInputsInline(true)
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('Update the value of a state property')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['set_state_property'] = function (block: any) {
    var text_property = block.getFieldValue('property')
    var value_value = luaGenerator.valueToCode(
      block,
      'value',
      luaGenerator.ORDER_ATOMIC
    )

    return 'state' + '.' + text_property + ' = ' + value_value + '\n'
  }

  Blockly.Blocks['get_state_property'] = {
    init: function () {
      this.appendDummyInput().appendField('Get state .')
      this.appendDummyInput().appendField(
        new Blockly.FieldTextInput('property'),
        'property'
      )
      this.setInputsInline(true)
      this.setOutput(true, null)
      this.setColour(230)
      this.setTooltip('Get the value of a state property')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['get_state_property'] = function (block: any) {
    var text_property = block.getFieldValue('property')

    return ['state' + '.' + text_property, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Blocks['change_state_property'] = {
    init: function () {
      this.appendDummyInput().appendField('Change state .')
      this.appendDummyInput()
        .appendField(new Blockly.FieldTextInput('property'), 'property')
        .appendField('using')
        .appendField(
          new Blockly.FieldDropdown([
            ['+', '+'],
            ['-', '-'],
            ['*', '*'],
            ['/', '/'],
            ['%', '%'],
          ]),
          'operator'
        )
        .appendField('by')
      this.appendValueInput('value').setCheck('Number')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setInputsInline(true)
      this.setColour(230)
      this.setTooltip('Arithmetic operation on an state property')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['change_state_property'] = function (block: any) {
    var objectProperty = block.getFieldValue('property')
    var operator = block.getFieldValue('operator')
    var changeValue = luaGenerator.valueToCode(
      block,
      'value',
      luaGenerator.ORDER_ATOMIC
    )

    return `state.${objectProperty} = state.${objectProperty} ${operator} ${changeValue}\n`
  }

  // Set FSM state code
  Blockly.Blocks['set_fsm_state'] = {
    init: function () {
      this.appendValueInput('STATE')
        .setCheck('String')
        .appendField('set FSM state to')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
    },
  }
  luaGenerator.forBlock['set_fsm_state'] = function (block: any) {
    var state =
      luaGenerator.valueToCode(block, 'STATE', luaGenerator.ORDER_ATOMIC) ||
      'new_state'
    var code = 'set_FSM_state(' + state + ')\n'

    return code
  }

  // get FSM state code
  Blockly.Blocks['get_fsm_state'] = {
    init: function () {
      this.setOutput(true, 'String')
      this.setColour(230)
      this.setTooltip('')
      this.setHelpUrl('')
      this.appendDummyInput().appendField('get FSM state')
    },
  }
  luaGenerator.forBlock['get_fsm_state'] = function () {
    var code = 'get_FSM_state()'
    return [code, luaGenerator.ORDER_ATOMIC]
  }

  Blockly.Msg.LOGIC_NULL = 'nil'

  // transition_if block.
  Blockly.Blocks['transition_if'] = {
    init: function () {
      this.appendValueInput('IF0').setCheck('String').appendField('If state in')
      this.appendStatementInput('DO0').setCheck(null).appendField('do')
      this.setPreviousStatement(true, null)
      this.setNextStatement(true, null)
      this.setColour(230)
      this.setTooltip('state transition')
      this.setHelpUrl('')
      this.elseifCount_ = 0
      this.elseCount_ = 0
      this.suppressPrefixSuffix = true
      this.setMutator(
        new Blockly.icons.MutatorIcon(
          ['transition_elseif', 'transition_else'],
          this
        )
      )
    },

    /**
     * Create XML to represent the number of else-if and else inputs.
     * Backwards compatible serialization implementation.
     */
    mutationToDom: function () {
      if (!this.elseifCount_ && !this.elseCount_) {
        return null
      }

      var container = Blockly.utils.xml.createElement('mutation')
      if (this.elseifCount_) {
        container.setAttribute('elseif', String(this.elseifCount_))
      }
      if (this.elseCount_) {
        container.setAttribute('else', '1')
      }

      return container
    },

    /**
     * Parse XML to restore the else-if and else inputs.
     * Backwards compatible serialization implementation.
     */
    domToMutation: function (xmlElement: any) {
      this.prevElseifCount_ = this.elseifCount_
      this.elseifCount_ = parseInt(xmlElement.getAttribute('elseif')!, 10) || 0
      this.elseCount_ = parseInt(xmlElement.getAttribute('else')!, 10) || 0
      this.rebuildShape_()
    },

    /**
     * Returns the state of this block as a JSON serializable object.
     *
     * @returns The state of this block, ie the else if count and else state.
     */
    saveExtraState: function (this: any): any | null {
      if (!this.elseifCount_ && !this.elseCount_) {
        return null
      }
      const state = Object.create(null)
      if (this.elseifCount_) {
        state['elseIfCount'] = this.elseifCount_
      }
      if (this.elseCount_) {
        state['hasElse'] = true
      }
      return state
    },

    /** Applies the given state to this block. */
    loadExtraState: function (this: any, state: any) {
      this.elseifCount_ = state['elseIfCount'] || 0
      this.elseCount_ = state['hasElse'] ? 1 : 0
      this.updateShape_()
    },

    /** Populate the mutator's dialog with this block's components. */
    decompose: function (this: any, workspace: any): any {
      const containerBlock = workspace.newBlock('transition_if_mutator')
      containerBlock.initSvg()
      let connection = containerBlock.nextConnection!
      for (let i = 1; i <= this.elseifCount_; i++) {
        const elseifBlock = workspace.newBlock('transition_elseif')
        elseifBlock.initSvg()
        connection.connect(elseifBlock.previousConnection!)
        connection = elseifBlock.nextConnection!
      }
      if (this.elseCount_) {
        const elseBlock = workspace.newBlock('transition_else')
        elseBlock.initSvg()
        connection.connect(elseBlock.previousConnection!)
      }
      return containerBlock
    },

    /** Reconfigure this block based on the mutator dialog's components. */
    compose: function (this: any, containerBlock: any) {
      let clauseBlock = containerBlock.nextConnection!.targetBlock()
      // Count number of inputs.
      this.elseifCount_ = 0
      this.elseCount_ = 0
      // Connections arrays are passed to .reconnectChildBlocks_() which
      // takes 1-based arrays, so are initialised with a dummy value at
      // index 0 for convenience.
      const valueConnections = [null]
      const statementConnections = [null]
      let elseStatementConnection = null
      while (clauseBlock) {
        if (clauseBlock.isInsertionMarker()) {
          clauseBlock = clauseBlock.getNextBlock()
          continue
        }
        switch (clauseBlock.type) {
          case 'transition_elseif':
            this.elseifCount_++
            // TODO(#6920): null valid, undefined not.
            valueConnections.push(clauseBlock.valueConnection_)
            statementConnections.push(clauseBlock.statementConnection_)
            break
          case 'transition_else':
            this.elseCount_++
            elseStatementConnection = clauseBlock.statementConnection_
            break
          default:
            throw TypeError('Unknown block type: ' + clauseBlock.type)
        }
        clauseBlock = clauseBlock.getNextBlock()
      }
      this.updateShape_()
      // Reconnect any child blocks.
      this.reconnectChildBlocks_(
        valueConnections,
        statementConnections,
        elseStatementConnection
      )
    },

    /** Store pointers to any connected child blocks. */
    saveConnections: function (this: any, containerBlock: any) {
      let clauseBlock = containerBlock!.nextConnection!.targetBlock()
      let i = 1
      while (clauseBlock) {
        if (clauseBlock.isInsertionMarker()) {
          clauseBlock = clauseBlock.getNextBlock()
          continue
        }
        switch (clauseBlock.type) {
          case 'transition_elseif': {
            const inputIf = this.getInput('IF' + i)
            const inputDo = this.getInput('DO' + i)
            clauseBlock.valueConnection_ =
              inputIf && inputIf.connection!.targetConnection
            clauseBlock.statementConnection_ =
              inputDo && inputDo.connection!.targetConnection
            i++
            break
          }
          case 'transition_else': {
            const inputDo = this.getInput('ELSE')
            clauseBlock.statementConnection_ =
              inputDo && inputDo.connection!.targetConnection
            break
          }
          default:
            throw TypeError('Unknown block type: ' + clauseBlock.type)
        }
        clauseBlock = clauseBlock.getNextBlock()
      }
    },

    /** Reconstructs the block with all child blocks attached. */
    rebuildShape_: function (this: any) {
      const valueConnections = [null]
      const statementConnections = [null]
      let elseStatementConnection = null

      if (this.getInput('ELSE')) {
        elseStatementConnection =
          this.getInput('ELSE')!.connection!.targetConnection
      }
      for (let i = 1; this.getInput('IF' + i); i++) {
        const inputIf = this.getInput('IF' + i)
        const inputDo = this.getInput('DO' + i)
        valueConnections.push(inputIf!.connection!.targetConnection)
        statementConnections.push(inputDo!.connection!.targetConnection)
      }
      this.updateShape_()
      this.reconnectChildBlocks_(
        valueConnections,
        statementConnections,
        elseStatementConnection
      )
    },

    /** Modify this block to have the correct number of inputs. */
    updateShape_: function (this: any) {
      // Delete everything.
      if (this.getInput('ELSE')) {
        this.removeInput('ELSE')
      }
      for (let i = 1; this.getInput('IF' + i); i++) {
        this.removeInput('IF' + i)
        this.removeInput('DO' + i)
      }
      // Rebuild block.
      for (let i = 1; i <= this.elseifCount_; i++) {
        this.appendValueInput('IF' + i)
          .setCheck('String')
          .appendField('else if state in')
        this.appendStatementInput('DO' + i).appendField(
          Blockly.Msg['CONTROLS_IF_MSG_THEN']
        )
      }
      if (this.elseCount_) {
        this.appendStatementInput('ELSE').appendField(
          Blockly.Msg['CONTROLS_IF_MSG_ELSE']
        )
      }
    },

    /** Reconnects child blocks. */
    reconnectChildBlocks_: function (
      this: any,
      valueConnections: any,
      statementConnections: any,
      elseStatementConnection: any
    ) {
      for (let i = 1; i <= this.elseifCount_; i++) {
        valueConnections[i]?.reconnect(this, 'IF' + i)
        statementConnections[i]?.reconnect(this, 'DO' + i)
      }
      elseStatementConnection?.reconnect(this, 'ELSE')
    },
  }

  // Mutator blocks. Do not extract.
  // Block representing the if statement in the transition_if mutator.
  Blockly.Blocks['transition_if_mutator'] = {
    init: function () {
      this.setColour(230)
      this.appendDummyInput().appendField('If state in')
      this.appendStatementInput('STACK')
      this.setPreviousStatement(true)
      this.setNextStatement(true)
      this.setTooltip(
        'Add, remove, or reorder sections to reconfigure this if state in block.'
      )
    },
  }

  // Block representing the else-if statement in the transition_if mutator.
  Blockly.Blocks['transition_elseif'] = {
    init: function () {
      this.setColour(230)
      this.appendDummyInput().appendField('else if state in')
      this.setPreviousStatement(true)
      this.setNextStatement(true)
      this.setTooltip('Add a condition to the if state in block.')
    },
  }

  // Block representing the else statement in the transition_if mutator.
  Blockly.Blocks['transition_else'] = {
    init: function () {
      this.setColour(230)
      this.appendDummyInput().appendField('else')
      this.setPreviousStatement(true)
      this.setTooltip(
        'Add a final, catch-all condition to the if state in block.'
      )
    },
  }

  // lua code for the transition_if block.
  luaGenerator.forBlock['transition_if'] = function (block: any) {
    var n = 0
    var argument =
      luaGenerator.valueToCode(block, 'IF' + n, luaGenerator.ORDER_NONE) || `''`
    var branch = luaGenerator.statementToCode(block, 'DO' + n) || ''
    var code = 'if get_FSM_state() == ' + argument + ' then\n' + branch

    for (n = 1; n <= block.elseifCount_; n++) {
      argument =
        luaGenerator.valueToCode(block, 'IF' + n, luaGenerator.ORDER_NONE) ||
        `''`
      branch = luaGenerator.statementToCode(block, 'DO' + n) || ''
      code += 'elseif get_FSM_state() == ' + argument + ' then\n' + branch
    }

    if (block.elseCount_) {
      branch = luaGenerator.statementToCode(block, 'ELSE') || ''
      code += 'else\n' + branch
    }

    return code + 'end\n'
  }

  // lua code for the transition_if mutator.
  luaGenerator.forBlock['transition_if_mutator'] = function (block: any) {
    var branch = luaGenerator.statementToCode(block, 'STACK')
    return branch
  }

  // lua code for the transition_if mutator elseif block.
  luaGenerator.forBlock['transition_elseif'] = function (block: any) {
    return 'else if'
  }

  // lua code for the transition_if mutator else block.
  luaGenerator.forBlock['transition_else'] = function (block: any) {
    return 'else'
  }
}
