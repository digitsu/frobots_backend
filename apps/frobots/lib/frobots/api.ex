defmodule Frobots.Api do
  alias Frobots.Events
  # this is the FE api for liveview pages

  def create_match(match_details) do
    Events.create_match(match_details)
  end

  def join_match(_user, _match) do
  end

  def create_frobot(_user, _name, _prototype) do
    _default_loadout = Frobots.default_frobot_loadout()

    # check that the user has enough sparks to create a frobot
    # create a frobot, with that name, using that prototype bot (name)
    # equip the frobot will all the default parts and xframe
    # create all the needed parts instances
    # save it into the db
    # IF successful, UPDATE the user and decrement sparks - 1.
    # return a frobot_name and id as success
  end
end
