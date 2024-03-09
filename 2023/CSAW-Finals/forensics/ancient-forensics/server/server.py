import yaml

def check_answer(question, check):
    print(question)
    while True:
        correct = False
        print("Please enter your answer: ", end='')
        answer = input("")
        for answer_type in check:
            answer_type = [x.lower() for x in answer_type.split(' ')]
            answer_array = answer.lower().split(' ')
            if all(x in answer_array for x in answer_type) and len(list(set(answer_array))) >= len(answer_type):
                print("That's right!")
                correct = True
                break
        if correct:
            break
        print("Not quite... Please try again!")

if __name__ == "__main__":
    with open("config.yaml", "r") as f:
        config = yaml.safe_load(f)
    print(config['intro'])
    total_questions = len(config['questions'])
    for number, question in config["questions"].items():
        check_answer(f"({number}/{total_questions}) " + question["question"], question["answer"])
    print(config['outro'])
    print(f"Here's your flag --> {config['flag']}")