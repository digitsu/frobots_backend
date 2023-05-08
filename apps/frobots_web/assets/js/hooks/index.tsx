import DashboardHook from './DashboardHook'
import FrobotsListHook from './FrobotsListHook'
import ArenaHomeHook from './ArenaHomeHook'
import FrobotCreateHook from './FrobotCreateHook'
import ArenaMatchesHook from './ArenaMatchesHook'
import FrobotDetailsHook from './FrobotDetailsHook'
import FrobotBrainCodeHook from './FrobotBrainCodeHook'
import ArenaCreateMatch from './ArenaCreateMatch'
import FrobotEquipmentBayHook from './FrobotEquipmentBayHook'
import ArenaLobbyHook from './ArenaLobbyHook'
import DocsHook from './DocsHook'
import UserProfileHook from './UserProfileHook'
import BlogsHook from './BlogsHook'
import ArenaMatchResults from './ArenaMatchResults'


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
Hooks.ArenaMatchesHook = ArenaMatchesHook
Hooks.FrobotDetailsHook = FrobotDetailsHook
Hooks.FrobotBrainCodeHook = FrobotBrainCodeHook
Hooks.ArenaCreateMatch = ArenaCreateMatch
Hooks.FrobotEquipmentBayHook = FrobotEquipmentBayHook
Hooks.ArenaLobbyHook = ArenaLobbyHook
Hooks.DocsHook = DocsHook
Hooks.UserProfileHook = UserProfileHook
Hooks.BlogsHook = BlogsHook
Hooks.ArenaMatchResults = ArenaMatchResults

export default Hooks
