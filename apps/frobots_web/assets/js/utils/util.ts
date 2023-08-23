import moment from 'moment'
import Blockly from 'blockly'

const characters =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'

export function generateRandomString(length = 5) {
  const charactersLength = characters.length
  let result = ''

  let counter = 0
  while (counter < length) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength))
    counter += 1
  }

  return result
}

export const slotMapper = (slots, current_user_id, user_id, s3ImageUrl = '') =>
  slots
    .map((slot) => {
      const slotType = slot.status?.toLowerCase()
      const slotImage = {
        open: '/images/frobot.svg',
        closed: '/images/grey_frobot.svg',
        host: '/images/red_frobot.svg',
        player: '/images/red_frobot.svg',
        protobot: '/images/yellow_frobot.svg',
        done: '/images/grey_frobot.svg',
      }
      if (slotType === 'open' || slotType === 'closed') {
        return {
          id: slot?.id,
          type: slot.status.toLowerCase(),
          url: slotImage[slotType],
          name: slotType === 'open' ? 'Open' : 'Closed',
          slotDetails: slot.frobot,
          current_user_id,
          frobot_user_id: slot.frobot_user_id,
          status: slotType,
        }
      } else if (slotType === 'done' && slot?.frobot === null) {
        return {
          id: slot?.id,
          type: slot.status.toLowerCase(),
          url: slotImage[slotType],
          name: 'Unoccupied',
          slotDetails: slot.frobot,
          current_user_id,
          frobot_user_id: slot.frobot_user_id,
          status: slotType,
        }
      } else {
        const isHostFrobot = slot?.frobot_user_id === user_id
        const frobotLabel = isHostFrobot
          ? `Host: ${slot.frobot?.name || ' '}`
          : `Player ${slot?.frobot_user_id || ' '}: ${slot.frobot?.name || ' '}`
        const name =
          slot?.slot_type?.toLowerCase() === 'protobot'
            ? `NPC : ${slot.frobot?.name || ' '}`
            : frobotLabel
        return {
          id: slot?.id,
          type: slot.status.toLowerCase(),
          url: `${s3ImageUrl}${slot?.frobot.avatar}`,
          name,
          slotDetails: slot.frobot,
          current_user_id,
          frobot_user_id: slot.frobot_user_id,
          status: slotType,
        }
      }
    })
    .sort((a, b) => a.id - b.id)

export const formatCounterTime = (time) => {
  const duration = moment.duration(time, 'seconds')
  const formattedDuration = moment
    .utc(duration.asMilliseconds())
    .format('HH:mm:ss')
  return formattedDuration
}

const blogPostImages = [
  '/images/blog-post/bg-1.png',
  '/images/blog-post/bg-2.png',
  '/images/blog-post/bg-3.png',
  '/images/blog-post/bg-4.png',
  '/images/blog-post/bg-5.png',
  '/images/blog-post/bg-6.png',
  '/images/blog-post/bg-7.png',
  '/images/blog-post/bg-8.png',
]

export const getBlogPostImage = () => {
  return blogPostImages[Math.floor(Math.random() * blogPostImages.length)]
}

export const handleTourCallback = (data, setShowTutorial) => {
  const toolbox = Blockly.getMainWorkspace().getToolbox()
  const flyout = toolbox.getFlyout()
  const isFlyOutVisible = flyout.isVisible_
  const toolBoxItems = toolbox.getToolboxItems()
  if (
    (data.index === 1 &&
      data.lifecycle === 'complete' &&
      data.action === 'next') ||
    (data.index === 2 &&
      data.lifecycle === 'complete' &&
      data.action === 'next') ||
    (data.index === 4 &&
      data.lifecycle === 'complete' &&
      data.action === 'prev')
  ) {
    if (!isFlyOutVisible) {
      const category = toolBoxItems.find(
        (toolBoxItem) => toolBoxItem.toolboxItemDef_.id === 'frobot-functions'
      )
      toolbox.setSelectedItem(category)
    }
  }
  if (
    (data.index === 4 &&
      data.lifecycle === 'complete' &&
      data.action === 'next') ||
    (data.index === 6 &&
      data.lifecycle === 'complete' &&
      data.action === 'prev') ||
    (data.index === 5 &&
      data.lifecycle === 'complete' &&
      data.action === 'prev')
  ) {
    const category = toolBoxItems.find(
      (toolBoxItem) => toolBoxItem.toolboxItemDef_.id === 'objects-category'
    )
    toolbox.setSelectedItem(category)
  }
  if (
    (data.index === 5 &&
      data.lifecycle === 'complete' &&
      data.action === 'next') ||
    (data.index === 7 &&
      data.lifecycle === 'complete' &&
      data.action === 'prev')
  ) {
    const mainCategory = toolBoxItems.find(
      (toolBoxItem) => toolBoxItem.name_ === 'Variables'
    )
    const category = mainCategory.toolboxItems_.find(
      (toolboxItem) => toolboxItem.toolboxItemDef_.id === 'catVariables'
    )
    mainCategory.setExpanded(true)
    toolbox.setSelectedItem(category)
  }
  if (
    (data.index === 6 &&
      data.lifecycle === 'complete' &&
      data.action === 'next') ||
    (data.index === 8 &&
      data.lifecycle === 'complete' &&
      data.action === 'prev')
  ) {
    const mainCategory = toolBoxItems.find(
      (toolBoxItem) => toolBoxItem.name_ === 'Variables'
    )
    mainCategory.setExpanded(false)

    const category = toolBoxItems.find(
      (toolBoxItem) => toolBoxItem.toolboxItemDef_.id === 'catText'
    )
    toolbox.setSelectedItem(category)
  }
  if (
    (data.index === 7 &&
      data.lifecycle === 'complete' &&
      data.action === 'next') ||
    (data.index === 9 &&
      data.lifecycle === 'complete' &&
      data.action === 'prev') ||
    (data.index === 8 &&
      data.lifecycle === 'complete' &&
      data.action === 'next')
  ) {
    const category = toolBoxItems.find(
      (toolBoxItem) => toolBoxItem.toolboxItemDef_.id === 'catLogic'
    )
    toolbox.setSelectedItem(category)
  }
  if (
    data.index === 5 &&
    data.lifecycle === 'complete' &&
    data.action === 'prev'
  ) {
    flyout.hide()
  }
  if (
    (data.action === 'reset' && data.type === 'tour:status') ||
    data.action === 'close'
  ) {
    setShowTutorial(false)
  }
}
