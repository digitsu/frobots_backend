import DashboardHook from './DashboardHook'
import FrobotsListHook from './FrobotsListHook'
import ArenaHomeHook from './ArenaHomeHook'
import FrobotCreateHook from './FrobotCreateHook'
import {
  LiveMatchesHook,
  UpcomingMatchesHook,
  PastMatchesHook,
} from './ArenaMatchesHook'
import FrobotDetailsHook from './FrobotDetailsHook'

interface HookType {
  [key: string]: {
    mounted(): void
    destroyed(): void
    opts(args: any): { name?: string }
    unmountComponent?(el: HTMLElement): void
  } & Partial<Record<string, unknown>>
}

const Hooks: Partial<HookType> = {}

Hooks.DashboardContentHook = DashboardHook
Hooks.FrobotsListHook = FrobotsListHook
Hooks.FrobotCreateHook = FrobotCreateHook
Hooks.ArenaContentHook = ArenaHomeHook
Hooks.LiveMatchesHook = LiveMatchesHook
Hooks.UpcomingMatchesHook = UpcomingMatchesHook
Hooks.PastMatchesHook = PastMatchesHook
Hooks.FrobotDetailsHook = FrobotDetailsHook

export default Hooks
