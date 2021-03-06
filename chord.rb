#ボイスリーディングプログラム
module Chord
    
    NOTES = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    
    private 
        def self.chord_tone_degrees(*degrees)
            ->(note) {degrees.include?(note%7)}
        end
    
    CODE_RULES = {
        :I => chord_tone_degrees(1,3,5),
        :IV => chord_tone_degrees(1,4,6),
        :V => chord_tone_degrees(2,5,0)
    }
    
    private_constant :NOTES
    private_constant :CODE_RULES
    
    class Chord
        
        attr_reader :chord_tones
        
        def initialize(chord_num: nil, bottom_note: nil, &chord_rule)
            raise 'parameter is invalid' unless validate_parameter(chord_num, chord_rule)
            chord_rule ||= CODE_RULES[:"#{chord_num.to_s.upcase}"]
            @available_notes = NOTES.filter(&chord_rule)
            @chord_tones = self.make_chord_tones(bottom_note: bottom_note)
        end
        
        def build_from(bottom_note)
            Chord.new(bottom_note: bottom_note) { |note|
                @available_notes.include?(note)
            }
        end
        
        def next(chord_num: nil, &chord_rule)
            next_chord = Chord.new(chord_num: chord_num, &chord_rule)
            next_chord.build_from next_chord.nearest_note_to(@chord_tones.min)
            next_chord
        end

        private
            def validate_parameter(chord_num, chord_rule)
                !chord_num.nil? || !chord_rule.nil?
            end
            
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
            
        protected
            def nearest_note_to(target_note)
                nearest_note_index = @chord_tones.map { |note|
                    target_note - note
                }.each_with_index.min[1]
                @chord_tones[nearest_note_index]
            end
    end
end

chord_I = Chord::Chord.new(chord_num: :i)
puts chord_I.build_from(3).next(chord_num: :iv).next(chord_num: :v).chord_tones


