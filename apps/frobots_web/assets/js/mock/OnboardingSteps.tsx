import React from 'react'
import { Box, Typography } from '@mui/material'

export const createFrobotOnboardingSteps = [
  {
    target: '.blocklyWorkspace',
    content: (
      <Box>
        <Typography variant="body2" sx={{ mb: 1 }}>
          This is the block grid. This is where you can write code by assembling
          code blocks.
        </Typography>{' '}
        <Typography variant="body2" sx={{ mb: 1 }}>
          First, let’s start at the basics.
        </Typography>{' '}
        <Typography variant="body2" sx={{ mb: 1 }}>
          A <b>FROBOT</b> is just 1 function. It is a function that is called in
          a loop in the virtual machine of the simulator.
        </Typography>
        <Typography variant="body2" sx={{ mb: 1 }}>
          {' '}
          The FROBOT takes a <code>state</code> variable, which is a map or a
          table that can contain fields.{' '}
        </Typography>
        <Box
          component={'img'}
          src={'/images/state_initialize.gif'}
          sx={{ borderRadius: 2, mb: 2 }}
        />
        <Typography variant="body2">
          {' '}
          This <code>state</code> variable is how your FROBOT can pass
          information from one execution cycle to another.'
        </Typography>
      </Box>
    ),
    disableBeacon: true,
  },
  {
    target: '.blocklyToolboxDiv',
    content: (
      <Box>
        <Typography variant="body2">
          On the left you will see blocks organized by category.
        </Typography>
      </Box>
    ),
  },
  {
    target: '#blockly-k',
    content: (
      <>
        <Typography variant="body2">
          So let’s create that function, by clicking on “FROBOT Functions”
          Category
        </Typography>
      </>
    ),
  },
  {
    target:
      '.blocklyFlyout[data-cached-height][data-cached-width] .blocklyWorkspace .blocklyBlockCanvas g.blocklyDraggable:nth-child(3)',
    content: (
      <Typography variant="body2">
        Now Select the <b>Create Frobot</b> block under the{' '}
        <b>“Frobot Functions”</b>
        Category, and drop it into the grid.
      </Typography>
    ),
  },
  {
    target: 'body',
    content: (
      <Box>
        <Typography>A Frobot should be a simple state machine.</Typography>
        <Typography>
          A <code>state</code> is just a status definition by text.
        </Typography>
        <Typography>
          So let’s create a simple FROBOTs that has 2 statuses,{' '}
          <b>“Do stuff”</b>, and <b>“run away”</b>.
        </Typography>
        <Typography>
          First create 2 text blocks, one called “do_stuff” and the other called
          “run_away”.
        </Typography>
        <Typography>
          Let’s create the statuses by setting the{' '}
          <code>state.status = “do_stuff”</code>
        </Typography>
      </Box>
    ),
  },
  {
    target:
      '.blocklyFlyout[data-cached-height][data-cached-width] .blocklyFlyoutBackground',
    content: (
      <Typography variant="body2">
        Go to the Objects section and select the block labelled{' '}
        <b>“Set property of object”</b>
      </Typography>
    ),
  },
  {
    target:
      '.blocklyFlyout[data-cached-height][data-cached-width] .blocklyFlyoutBackground',
    content: (
      <Box>
        <Typography variant="body2">
          Next let's create a variable called <code>state</code> using{' '}
          <b>create variable</b> button from the Variables/List Variables
          section and drop it into the first part of{' '}
          <b>“Set property of object”</b>
          block and type “status” into the subfield of the state object.
        </Typography>
      </Box>
    ),
    placement: 'bottom',
  },
  {
    target:
      '.blocklyFlyout[data-cached-height][data-cached-width] .blocklyFlyoutBackground',
    content: (
      <Typography variant="body2">
        Next drop the text block called “do_stuff” and put that into the status
        field of the state object. This is how we can set the state in code{' '}
      </Typography>
    ),
  },
  {
    target:
      '.blocklyFlyout[data-cached-height][data-cached-width] .blocklyFlyoutBackground',
    content: (
      <Typography variant="body2">
        {' '}
        To test for what state you are in, you can use the Logic block which can
        test for equality. It is the block with 2 emply slots and an equal sign
        in the middle.'{' '}
      </Typography>
    ),
  },
  {
    target: '.blocklyWorkspace',
    content: (
      <Typography variant="body2">
        To be simple, let’s make the “Do Stuff” do something simple like move in
        a random direction, and to fire in a random direction. In a real frobot,
        you will likely want to do something more interesting that this! The{' '}
        <b>“run away”</b> status will be when your FROBOT is hit by another.
        Once you have determined the states that your FROBOT will support, then
        you will need to define which is the default state, or the state that
        your FROBOT starts in. For each other state, you must think about how
        your FROBOT enters this state, and how it exits it.
      </Typography>
    ),
  },
  {
    target: '.monaco-editor',
    content: (
      <Typography variant="body2">
        You will see as you drop the blocks into the grid, the resultant code
        appears in the right.{' '}
      </Typography>
    ),
  },
  {
    target: '.blocklyWorkspace',
    content: (
      <Typography variant="body2">
        Though you can edit this code, it is recommended that you refrain from
        doing so as it is not going to be represented by the block
        representation. Building a frobot generally means embedding
        <b>IF-DO</b> blocks testing which status the frobot is in, and doing
        stuff appropriately. This may include driving somewhere, via the block{' '}
        <b>Drive</b>
        (found in Frobot Functions) or <b>Cannon</b> which fires its cannon. You
        can test the current state of the FROBOTs by calling <b>Scan</b> or{' '}
        <b>Damage</b> to see what your current damage is. You can test this
        against previous values to see if you are shot! That’s generally it!
      </Typography>
    ),
  },
]
