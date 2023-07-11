defmodule Frobots.Blockchain do
  @moduledoc """
  The Blockchain context.
  """

  @priv_dir :code.priv_dir(:frobots)
  def run() do
    BSV.Contract.P2PKH

    BSV.Script.from_asm(
      "OP_DUP OP_HASH160 5ae866af9de106847de6111e5f1faa168b2be689 OP_EQUALVERIFY OP_CHECKSIG"
    )

    path = Path.join([@priv_dir, "Template 2.115041.1.nospace.txt"])
    asm = File.read!(path)
    BSV.Script.from_asm(asm)
  end
end
