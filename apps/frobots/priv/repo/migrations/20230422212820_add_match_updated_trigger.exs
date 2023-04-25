defmodule Frobots.Repo.Migrations.AddMatchUpdatedTrigger do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION notify_match_status()
      RETURNS trigger AS $trigger$
      DECLARE
        payload TEXT;
      BEGIN
        IF (TG_OP = 'UPDATE') AND (OLD.status != NEW.status) AND (NEW.status = 'done') THEN
          payload := json_build_object('id',OLD.id,'old',row_to_json(OLD),'new',row_to_json(NEW));
          PERFORM pg_notify('match_status_updated', payload);
        END IF;

        RETURN NEW;
      END;
      $trigger$ LANGUAGE plpgsql;
    """

    execute """
    CREATE TRIGGER match_status_changed_trigger
      AFTER UPDATE ON matches FOR EACH ROW
      WHEN ( OLD.status IS DISTINCT FROM NEW.status )
      EXECUTE PROCEDURE notify_match_status();
    """
  end

  def down do
    execute """
    DROP TRIGGER match_status_changed_trigger ON matches;
    """

    execute """
    DROP FUNCTION notify_match_status();
    """
  end
end
