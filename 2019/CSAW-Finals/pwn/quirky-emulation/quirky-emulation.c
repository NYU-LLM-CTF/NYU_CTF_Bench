#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <inttypes.h>
#include <sys/mman.h>
#include <stdbool.h>

struct list
{
	uint32_t* contents;
	uint32_t count;
	struct list* next;
};

struct list* head = NULL;

int get_num(uint32_t* n)
{
	char line[32];
	if (!fgets(line, 31, stdin))
		return 0;
	if ((line[0] == 0) || (line[0] == '\n'))
		return 0;
	*n = strtoul(line, NULL, 0);
	return 1;
}

void new_list()
{
	printf("Count:\n");
	fflush(stdout);
	uint32_t count;
	if (!get_num(&count))
		return;
	if (count > (0xffffffff / 4))
	{
		printf("Too large\n");
		return;
	}

	uint32_t* nums = (uint32_t*)mmap(NULL, count * 4, PROT_READ | PROT_WRITE,
		MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
	if (nums == MAP_FAILED)
	{
		printf("Allocation failed\n");
		return;
	}

	struct list* item = (struct list*)malloc(sizeof(struct list));
	item->contents = nums;
	item->count = count;
	item->next = head;
	head = item;
}

void edit_list()
{
	printf("List index:\n");
	fflush(stdout);
	uint32_t list_index;
	if (!get_num(&list_index))
		return;

	uint32_t i = 0;
	struct list* cur;
	for (cur = head; cur; cur = cur->next, i++)
	{
		if (list_index == i)
			break;
	}
	if (!cur)
	{
		printf("Invalid index\n");
		return;
	}

	printf("List has %u entries\n", cur->count);
	while (1)
	{
		printf("Entry to edit (blank to end):\n");
		fflush(stdout);
		uint32_t entry;
		if (!get_num(&entry))
			break;
		if (entry >= cur->count)
		{
			printf("Invalid entry\n");
			continue;
		}
		printf("Existing value is %u\n", cur->contents[entry]);
		printf("New value:\n");
		fflush(stdout);
		uint32_t val;
		if (!get_num(&val))
			break;
		cur->contents[entry] = val;
	}
}

void avg_list()
{
	printf("List index:\n");
	fflush(stdout);
	uint32_t list_index;
	if (!get_num(&list_index))
		return;

	uint32_t i = 0;
	struct list* cur;
	for (cur = head; cur; cur = cur->next, i++)
	{
		if (list_index == i)
			break;
	}
	if (!cur)
	{
		printf("Invalid index\n");
		return;
	}

	uint64_t sum = 0;
	for (uint32_t i = 0; i < cur->count; i++)
		sum += (uint64_t)cur->contents[i];
	sum /= (uint64_t)cur->count;
	printf("\nAverage is %u\n\n", (uint32_t)sum);
}

int main(int argc, char* argv[])
{
	struct list default_list;
	uint32_t default_values[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
	default_list.count = 10;
	default_list.contents = default_values;
	default_list.next = NULL;
	head = &default_list;
	while (1)
	{
		uint32_t i = 0;
		printf("Current lists:\n");
		struct list* cur;
		for (cur = head; cur; cur = cur->next)
			printf("%u: List of %u items\n", i, cur->count);
		if (!head)
			printf("No lists\n");
		printf("\n1) Create a new list\n");
		printf("2) Edit an existing list\n");
		printf("3) Show average of a list\n");
		fflush(stdout);

		uint32_t choice;
		if (!get_num(&choice))
			return 0;

		switch (choice)
		{
		case 1:
			new_list();
			break;
		case 2:
			edit_list();
			break;
		case 3:
			avg_list();
			break;
		default:
			break;
		}
	}
}
