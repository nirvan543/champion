//
//  MatchLegProgressView.swift
//  Champion
//
//  Created by Nirvan Nagar on 7/16/22.
//

import SwiftUI

struct MatchLegProgressView: View {
    
    enum FocusField {
        case minute
        case seconds
        case distance
    }
    
    @Binding var matchLeg: MatchLeg
    private let legNumber: Int
    
    @State private var minute: String = ""
    @State private var seconds: String = ""
    @State private var distance: String = ""
    @State private var scorer: Participant
    @State private var showDeleteGoalAlert = false
    @State private var goalToDelete: Goal? = nil
    
    @FocusState private var focusField: FocusField?
    
    init(matchLeg: Binding<MatchLeg>, legNumber: Int) {
        _matchLeg = matchLeg
        self.legNumber = legNumber
        
        _scorer = State(initialValue: matchLeg.wrappedValue.homeParticipant)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 42) {
                LegsCellView(leg: matchLeg)
                
                PageSection(headerText: "Score Card") {
                    ScoreCellView(participant1Score: matchLeg.homeScore, participant2Score: matchLeg.awayScore)
                }
                
                goalsSection
                actionSection
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
        .background(DesignValues.pageColor.ignoresSafeArea())
        .navigationTitle("Leg \(legNumber)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if matchLeg.legState == .completed {
                    Button {
                        matchLeg.reactivateLeg()
                    } label: {
                        Text("Edit")
                    }
                }
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusField = nil
                }
            }
        }
        .alert("Delete goal?",
               isPresented: $showDeleteGoalAlert,
               presenting: goalToDelete) { goal in
            
            Button("Delete", role: .destructive) {
                matchLeg.goals.removeAll(where: { $0 == goal })
                goalToDelete = nil
            }
        }
    }
    
    private var goalsSection: some View {
        PageSection(headerText: "Goals") {
            VStack(spacing: 25) {
                goalsListSection
                
                if matchLeg.legState == .inProgress {
                    goalsInputSection
                }
            }
        }
    }
    
    private var goalsListSection: some View {
        VStack {
            ForEach(matchLeg.goals) { goal in
                ZStack {
                    GoalCellView(goal: goal)
                    
                    if matchLeg.legState == .inProgress {
                        deleteGoalButton(goal: goal)
                            .offset(x: 10, y: -10)
                    }
                }
            }
        }
    }
    
    private func deleteGoalButton(goal: Goal) -> some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    goalToDelete = goal
                    showDeleteGoalAlert = true
                } label: {
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 22, height: 20)
                }
                Spacer()
            }
        }
    }
    
    private var goalsInputSection: some View {
        VStack(spacing: 10) {
            HStack {
                TextField("Minute", text: $minute)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .minute)
                TextField("Seconds", text: $seconds)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .seconds)
                TextField("Distance", text: $distance)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .distance)
            }
            HStack {
                Picker("Scorer", selection: $scorer) {
                    Text(matchLeg.homeParticipant.playerName)
                        .tag(matchLeg.homeParticipant)
                    Text(matchLeg.awayParticipant.playerName)
                        .tag(matchLeg.awayParticipant)
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.quaternary, lineWidth: 1))
                
                Button {
                    saveGoal()
                } label: {
                    Text("Add")
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    @ViewBuilder
    private var actionSection: some View {
        PageSection {
            if matchLeg.legState == .notStarted {
                Button {
                    matchLeg.startLeg()
                } label: {
                    Text("Start Leg")
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            } else if matchLeg.legState == .inProgress {
                Button {
                    matchLeg.completeLeg()
                } label: {
                    Text("Complete Leg")
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            } else {
                EmptyView()
            }
        }
    }
    
    private func saveGoal() {
        guard let minute = Int(minute),
              let seconds = Int(seconds),
              let distance = Int(distance) else {
            return
        }
        
        let goal = Goal(id: IdUtils.newUuid,
                        scorer: scorer,
                        against: scorer == matchLeg.homeParticipant ? matchLeg.awayParticipant : matchLeg.homeParticipant,
                        minute: minute,
                        second: seconds,
                        distance: distance)
        
        matchLeg.goals.append(goal)
        matchLeg.goals.sort { goal1, goal2 in
            (goal1.minute, goal1.second) < (goal2.minute, goal2.second)
        }
        
        self.minute = ""
        self.seconds = ""
        self.distance = ""
        
        focusField = nil
    }
}

struct MatchLegProgressView_Previews: PreviewProvider {
    @State private static var legExample1 = MatchLeg(id: IdUtils.newUuid,
                                                     homeParticipant: MockData.mahendra,
                                                     awayParticipant: MockData.saurav,
                                                     goals: [],
                                                     legState: .notStarted)
    
    @State private static var legExample2 = MatchLeg(id: IdUtils.newUuid,
                                                     homeParticipant: MockData.keerti,
                                                     awayParticipant: MockData.mookie,
                                                     goals: [
                                                        Goal(id: IdUtils.newUuid,
                                                             scorer: MockData.mookie,
                                                             against: MockData.keerti,
                                                             minute: 14,
                                                             second: 21,
                                                             distance: 21)
                                                     ],
                                                     legState: .inProgress)
    
    @State private static var legExample3 = MatchLeg(id: IdUtils.newUuid,
                                                     homeParticipant: MockData.antriksh,
                                                     awayParticipant: MockData.neeraj,
                                                     goals: [
                                                        Goal(id: IdUtils.newUuid,
                                                             scorer: MockData.antriksh,
                                                             against: MockData.neeraj,
                                                             minute: 14,
                                                             second: 21,
                                                             distance: 21),
                                                        Goal(id: IdUtils.newUuid,
                                                             scorer: MockData.antriksh,
                                                             against: MockData.neeraj,
                                                             minute: 42,
                                                             second: 21,
                                                             distance: 14),
                                                        Goal(id: IdUtils.newUuid,
                                                             scorer: MockData.neeraj,
                                                             against: MockData.antriksh,
                                                             minute: 81,
                                                             second: 22,
                                                             distance: 44)
                                                     ],
                                                     legState: .completed)
    
    static var previews: some View {
        Group {
            NavigationView {
                MatchLegProgressView(matchLeg: $legExample1, legNumber: 1)
            }
            NavigationView {
                MatchLegProgressView(matchLeg: $legExample2, legNumber: 1)
            }
            NavigationView {
                MatchLegProgressView(matchLeg: $legExample3, legNumber: 1)
            }
        }
    }
}
