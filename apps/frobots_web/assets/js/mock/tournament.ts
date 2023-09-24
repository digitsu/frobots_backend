import { IRoundProps } from 'react-brackets'

export const matches: IRoundProps[] = [
  {
    title: 'Round of 32',
    seeds: [
      {
        id: 1,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot A' }, { name: 'Frobot B' }],
      },
      {
        id: 2,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
      {
        id: 1,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot A' }, { name: 'Frobot B' }],
      },
      {
        id: 2,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
      {
        id: 1,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot A' }, { name: 'Frobot B' }],
      },
      {
        id: 2,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
      {
        id: 1,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot A' }, { name: 'Frobot B' }],
      },
      {
        id: 2,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
    ],
  },
  {
    title: 'Quarter Finals',
    seeds: [
      {
        id: 3,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
      {
        id: 4,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
      {
        id: 3,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
      {
        id: 4,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot C' }, { name: 'Frobot D' }],
      },
    ],
  },
  {
    title: 'Semi - Finals',
    seeds: [
      {
        id: 3,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot A' }, { name: 'Frobot C' }],
      },
      {
        id: 4,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot B' }, { name: 'Frobot D' }],
      },
    ],
  },
  {
    title: 'Finals',
    seeds: [
      {
        id: 3,
        date: new Date().toDateString(),
        teams: [{ name: 'Frobot A' }, { name: 'Frobot B' }],
      },
    ],
  },
]

export const tournamentPool1 = [
  {
    name: 'Optimus Prime',
    avatar: '',
    player: 'Linda Martinez',
    xp: 3245,
    wins: 7,
    loses: 2,
  },
  {
    name: 'Megatron',
    avatar: '',
    player: 'Chris Wilson',
    xp: 1436,
    wins: 3,
    loses: 1,
  },
  {
    name: 'RoboCop',
    avatar: '',
    player: 'David Lee',
    xp: 4127,
    wins: 6,
    loses: 3,
  },
  {
    name: 'Bender',
    avatar: '',
    player: 'Alice Brown',
    xp: 5802,
    wins: 2,
    loses: 4,
  },
  {
    name: 'Terminator',
    avatar: '',
    player: 'Jane Smith',
    xp: 2198,
    wins: 5,
    loses: 0,
  },
  {
    name: 'C-3PO',
    avatar: '',
    player: 'Emily Davis',
    xp: 4712,
    wins: 8,
    loses: 2,
  },
  {
    name: 'Ultron',
    avatar: '',
    player: 'Sarah Taylor',
    xp: 5248,
    wins: 9,
    loses: 4,
  },
  {
    name: 'WALL-E',
    avatar: '',
    player: 'John Doe',
    xp: 3427,
    wins: 4,
    loses: 3,
  },
  {
    name: 'Bumblebee',
    avatar: '',
    player: 'Mike Anderson',
    xp: 1982,
    wins: 1,
    loses: 2,
  },
  {
    name: 'R2-D2',
    avatar: '',
    player: 'David Lee',
    xp: 3789,
    wins: 7,
    loses: 1,
  },
]

export const tournamentPool2 = [
  {
    name: 'Bumblebee',
    avatar: '',
    player: 'Alice Brown',
    xp: 4791,
    wins: 6,
    loses: 1,
  },
  {
    name: 'Megatron',
    avatar: '',
    player: 'Chris Wilson',
    xp: 2341,
    wins: 3,
    loses: 0,
  },
  {
    name: 'R2-D2',
    avatar: '',
    player: 'Sarah Taylor',
    xp: 4372,
    wins: 7,
    loses: 4,
  },
  {
    name: 'RoboCop',
    avatar: '',
    player: 'Linda Martinez',
    xp: 5902,
    wins: 8,
    loses: 3,
  },
  {
    name: 'WALL-E',
    avatar: '',
    player: 'David Lee',
    xp: 1912,
    wins: 2,
    loses: 0,
  },
  {
    name: 'C-3PO',
    avatar: '',
    player: 'Jane Smith',
    xp: 3987,
    wins: 6,
    loses: 1,
  },
  {
    name: 'Ultron',
    avatar: '',
    player: 'Emily Davis',
    xp: 5273,
    wins: 9,
    loses: 2,
  },
  {
    name: 'Optimus Prime',
    avatar: '',
    player: 'Mike Anderson',
    xp: 3489,
    wins: 5,
    loses: 2,
  },
  {
    name: 'Terminator',
    avatar: '',
    player: 'John Doe',
    xp: 2934,
    wins: 4,
    loses: 3,
  },
  {
    name: 'Bender',
    avatar: '',
    player: 'David Lee',
    xp: 3656,
    wins: 3,
    loses: 2,
  },
]

export const tournamentMatches = [
  {
    title: 'Match 11',
    description: 'First tournament match',
    match_time: '20 Aug 2023',
    timer: 3600,
    status: 'pending',
    tournament_match_type: 'Group Match',
    slots: [
      {
        frobot: {
          name: 'X Tron 10',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/1.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'ready',
      },
      {
        frobot: {
          name: 'X Tron 11',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/5.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'ready',
      },
    ],
  },
  {
    title: 'Match 32',
    description: 'Second tournament match',
    match_time: '20 Aug 2023',
    timer: 3600,
    status: 'running',
    tournament_match_type: 'Group Match',
    slots: [
      {
        frobot: {
          name: 'X Tron 4',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/2.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'ready',
      },
      {
        frobot: {
          name: 'X Tron 5',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/3.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'ready',
      },
    ],
  },
  {
    title: 'Match 23',
    description: 'Third tournament match',
    match_time: '20 Aug 2023',
    timer: 3600,
    status: 'done',
    tournament_match_type: 'Group Match',
    slots: [
      {
        frobot: {
          name: 'necron99',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/8.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'won',
      },
      {
        frobot: {
          name: 'Harbinger',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/9.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'lost',
      },
    ],
  },
  {
    title: 'Match 42',
    description: 'Fourth tournament match',
    match_time: '20 Aug 2023',
    timer: 3600,
    status: 'cancelled',
    tournament_match_type: 'Group Match',
    slots: [
      {
        frobot: {
          name: 'Megatron',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/10.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'ready',
      },
      {
        frobot: {
          name: 'Bumblebee',
          brain_code: null,
          class: null,
          xp: 60,
          blockly_code: null,
          avatar: 'images/frobots/12.png',
        },
        frobot_id: 20,
        frobot_user_id: 3,
        id: 1852,
        match_id: 655,
        slot_type: 'host',
        status: 'ready',
      },
    ],
  },
]
