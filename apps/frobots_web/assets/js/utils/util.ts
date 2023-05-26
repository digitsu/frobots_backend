import moment from 'moment'

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
