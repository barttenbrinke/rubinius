require File.expand_path('../../../../spec_helper', __FILE__)
require 'rubinius/actor'

describe "Actor.spawn_link" do
  it "sends an exit message to linked Rubinius::Actors" do
    actor = Rubinius::Actor.spawn_link do
      Rubinius::Actor.spawn_link do
        Rubinius::Actor.spawn_link do
          Rubinius::Actor.receive do |m|
            m.when(:die) { raise 'dying' }
          end
        end
      end
    end

    actor << :die
    msg = Rubinius::Actor.receive
    msg[0].should == :exit
  end
end
