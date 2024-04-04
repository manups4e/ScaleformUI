function isNullOrWhiteSpace(value: string | null): boolean {
    return value === null || value.trim() === '';
}
