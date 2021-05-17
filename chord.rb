# Your code here!
#ボイスリーディングプログラム

module Chord
    
    NOTES = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    
    CODE_RULES = {
        :I => ->(note){[1,3,5].include?(note%7)},
        :IV => ->(note){[1,4,6].include?(note%7)}
    }
    
    private_constant :NOTES
    private_constant :CODE_RULES
    
    class Chord
        
        attr_reader :chord_tones
        
        def initialize(chord_num: nil, bottom_note: nil, &chord_rule)
            raise 'undifined initialize params' if chord_num.nil? && chord_rule.nil?
            chord_rule ||= CODE_RULES[:"#{chord_num.to_s.upcase}"]
            @available_notes = NOTES.filter(&chord_rule)
            @chord_tones = self.make_chord_tones(bottom_note: bottom_note)
        end
        
        def build_from(bottom_note)
            Chord.new(bottom_note: bottom_note) { |note|
                @available_notes.include?(note)
            }
        end

        private
            def make_chord_tones(bottom_note: nil)
                bottom_note ||= @available_notes[0]
                raise "note#{bottom_note} is not exist" unless @available_notes.include?(bottom_note)
                index_of_bottom_note = @available_notes.find_index(bottom_note)
                [
                    @available_notes[index_of_bottom_note],
                    @available_notes[index_of_bottom_note+1],
                    @available_notes[index_of_bottom_note+2]
                ]
            end
    end
    

end

chord_I = Chord::Chord.new(chord_num: :i)
puts chord_I.build_from(5).chord_tones

class Chordu
    attr_reader :chord_tones
    
    
    
    def initialize(key: :c, bottom_note: nil, &chord_rule)
        available_notes = Chord::NOTES.filter(&chord_rule)
        raise "invalide bottom_note" unless available_notes.include?(bottom_note)
        index_of_bottom_note = available_notes.find_index(bottom_note)
        @key = key
        @chord_tones = [
            available_notes[index_of_bottom_note],
            available_notes[index_of_bottom_note+1],
            available_notes[index_of_bottom_note+2]
        ]
    end

    
    def next(&chord_rule)
        bottom_tone = @chord_tones.min
        next_chord_tones = Chord::NOTES.filter(&chord_rule)
        next_bottom_note = next_chord_tones[next_chord_tones.map{|tone| (bottom_tone-tone).abs}.each_with_index.min[1]]
        Chord.new(key: @key, bottom_note:next_bottom_note, &chord_rule)
    end
    
    private 
end


